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

print Dumper(\@static_apps,\@php_apps,\@proxy_servers,\@rack_apps,\@python_apps);

sub error_format {}
