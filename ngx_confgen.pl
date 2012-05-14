#!/usr/bin/env perl
use strict;
use Data::Dumper;
use Getopt::Long;
use File::Spec;
use File::Basename;

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

my $rack_template = "$template_dir/rack.conf.tmpl";
my $proxy_template = "$template_dir/proxy.conf.tmpl";


print $$static[0]{'server_name'};

sub hosted_app_info {
    my $apps = shift; # Get a reference of applications list
    my $app_type = shift;
    my @apps = @$apps; # Dereference application list
    my @servers; # Defined servers
    foreach my $app (@apps) {
	my @fields = split /:/, $app;
	my $server_name = join(" ", split(/,/, shift @fields));
	my $server_root = shift @fields;
	my %server_instance = ('server_name' => $server_name, 'server_root' => $server_root, 'type' => $app_type);
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
	my $server_name = join(" ", split(/,/, shift @fields));
	my @backends = split(/,/, shift @fields);
	my %proxy_instance = ('server_name' => $server_name, 'backend' => \@backends, 'type' => $proxy_type);
	push @servers, \%proxy_instance;
    }
    return \@servers;
}

sub process_template {
    my $template = shift;
    my $arguments = shift;
    my $output;

    return $output;
}
