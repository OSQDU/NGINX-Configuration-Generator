#!/usr/bin/env perl
use strict;
use Data::Dumper;
use Getopt::Long;
use File::Spec;
use File::Basename;
use Switch;

my @static_apps;
my @php_apps;
my @rack_apps;
my @python_apps;
my @proxy_servers;

GetOptions (
    "static=s" => \@static_apps,
    "php=s" => \@php_apps,
    "proxy=s" => \@proxy_servers,
    "rack=s" => \@rack_apps,
    "python=s" => \@python_apps);

my $static = hosted_app_info(\@static_apps,"static");
my $php = hosted_app_info(\@php_apps, "php");
my $rack = hosted_app_info(\@rack_apps, "rack");
my $python = hosted_app_info(\@python_apps, "python");
my $proxy = proxy_info(\@proxy_servers, "reverseproxy");
#print Dumper($static,$php,$rack,$python,$proxy);

my $base_dir = dirname(File::Spec->rel2abs(__FILE__));
my $template_dir = "$base_dir/lib/templates";

my %templates = (rack => "$template_dir/rack.conf.tmpl", reverseproxy => "$template_dir/proxy.conf.tmpl");

generate_server_block($rack);
generate_server_block($proxy);

sub generate_server_block {
    my @servers = @{$_[0]}; # dereference $_[0], the first arugment
    foreach my $server (@servers) {
	my @server_names = @{$$server{'server_names'}}; # deref $server, a hash
	my %parameters = (
	    'SERVER_NAMES' => join(" ", @server_names),
	    'SERVER_NAME_MASTER' => $server_names[0]
	    );

	switch ($$server{'type'}) {
	    case ["rack","python", "php", "static"] {
		$parameters{ROOT_PATH} = $$server{'server_root'};
		print process_hosted_template($templates{$$server{type}}, \%parameters);
	    }
	    case "reverseproxy" {
		$parameters{'BACKEND_URLS'} = $$server{'backends'};
		my @fqdn = split(/\./, $server_names[0]);
		my $upstream_name = join("_", @fqdn[0,1])."-".generate_random_string(5);
		$parameters{'UPSTREAM_NAME'} = $upstream_name;
		print process_proxy_template($templates{$$server{type}}, \%parameters);
	    }
	}
    }
}

sub hosted_app_info {
    my $apps = shift; # Get a reference of applications list
    my $app_type = shift;
    my @apps = @$apps; # Dereference application list
    my @servers; # Defined servers
    foreach my $app (@apps) {
	my @fields = split /:/, $app;
	#my $server_name = join(" ", split(/,/, shift @fields));
	my @server_names = split(/,/, shift @fields);
	my $server_root = shift @fields;
	my %server_instance = ('server_names' => \@server_names, 'server_root' => $server_root, 'type' => $app_type);
	push @servers, \%server_instance;
    }
    return \@servers;
}

sub proxy_info {
    my $proxies = shift;
    my $proxy_type = shift;
    my @proxies = @$proxies;
    my @servers;
    foreach my $proxy (@proxies) {
	my @fields = split /:/, $proxy, 2; # Only split to 2 parts;
	my @server_names = split(/,/, shift @fields);
	my @backends = split(/,/, shift @fields);
	my %proxy_instance = ('server_names' => \@server_names, 'backends' => \@backends, 'type' => $proxy_type);
	push @servers, \%proxy_instance;
    }
    return \@servers;
}

sub process_hosted_template {
    my $template_file = shift;
    my $arguments = shift; # a ref of argument
    my %arguments = %$arguments; # dereferenced hash
    # my $variable_names = join("|", keys(%arguments));
    my $output;
    open(my $fh, "<", $template_file);
    while (<$fh>) {
	$_ =~ s/#\{(.*)\}/$arguments{$1}/e;
	$output .= $_;
    }
    return $output;
}

sub process_proxy_template {
    my $template_file = shift;
    my $arguments = shift;
    my %arguments = %$arguments;
    my $output = "upstream $arguments{UPSTREAM_NAME} \{\n";
    my @backends = @{$arguments{'BACKEND_URLS'}};
    foreach my $backend (@backends) {
	$output .= "    server $backend max_fails=5 fail_timeout=30s;\n";
    }
    $output .= "\}\n";
    open(my $fh, "<", $template_file);
    while (<$fh>) {
	$_ =~ s/#\{(.*)\}/$arguments{$1}/e;
	$output .= $_;
    }
    return $output;
}

sub generate_random_string {
    my $length_of_randomstring=shift;
    my @chars=('a'..'z','A'..'Z','0'..'9');
    my $random_string;
    foreach (1..$length_of_randomstring) 
    {
	$random_string.=$chars[rand @chars];
    }
    return $random_string;
}

