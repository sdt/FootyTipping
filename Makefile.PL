#!/usr/bin/env perl

use inc::Module::Install;
use Module::Install::Catalyst;

name 'Tipping';
all_from 'lib/Tipping/WebApp.pm';

requires 'Catalyst::Runtime' => '5.80032';
requires 'Catalyst::Plugin::Session::Store::FastMmap';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Model::Adaptor';
requires 'Catalyst::Restarter';

requires 'CatalystX::SimpleLogin';

requires 'Config::ZOMG';
requires 'Data::Dumper::Concise';
requires 'DateTime::Format::Pg';
requires 'DBD::Pg';
requires 'DBIx::Class::DeploymentHandler';
requires 'DBIx::Class::EncodedColumn';
requires 'DBIx::Class::TimeStamp';
requires 'File::Slurp';
requires 'Getopt::Lazy';
requires 'GraphViz';
requires 'Hash::MoreUtils';
requires 'indirect';
requires 'Modern::Perl';
requires 'YAML::XS';
requires 'WWW::Mechanize';

test_requires 'Test::Pod::Coverage';
test_requires 'Test::Perl::Critic';
test_requires 'Test::mysqld';
test_requires 'Test::postgresql';
test_requires 'Devel::Cover';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
