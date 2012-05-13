#!/usr/bin/env perl
use strict;
use Data::Dumper;
use Getopt::Long;

my @static_apps;
my @php_apps;
my @proxy_servers;
my @rack_apps;
my @python_apps;

GetOptions (
    "static=s" => \@static_apps,
    "php=s" => \@php_apps,
    "proxy=s" => \@proxy_servers,
    "rack=s" => \@rack_apps,
    "python=s" => \@python_apps);

my @static;
foreach my $static_app (@static_apps) {
    my @fields = split /:/,$static_app;
    my $server_names = join(" ",split (/,/, shift @fields));
    my $server_root = shift @fields;
    my %static_item = ('server_name' => $server_names, 'server_root' => $server_root);
    push @static, \%static_item;
}

print Dumper(\@static);
print Dumper(\@static_apps,\@php_apps,\@proxy_servers,\@rack_apps,\@python_apps);

sub error_format {}
