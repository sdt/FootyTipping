#!/usr/bin/env perl

use inc::Module::Install;
use Module::Install::Catalyst;

name 'Tipping';
all_from 'lib/Tipping/WebApp.pm';

requires 'Catalyst::Runtime' => '5.80032';
requires 'Catalyst::Plugin::Session::Store::FastMMap';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Authentication::Store::DBIx::Class';
requires 'Catalyst::Restarter';

requires 'CatalystX::SimpleLogin';

requires 'Config::ZOMG';
requires 'Data::Dumper::Concise';
requires 'DBD::Pg';
requires 'DBIx::Class::DeploymentHandler';
requires 'DBIx::Class::EncodedColumn';
requires 'DBIx::Class::TimeStamp';
requires 'File::Slurp';
requires 'Getopt::Lazy';
requires 'Hash::MoreUtils';
requires 'Modern::Perl';
requires 'YAML::XS';

test_requires 'Test::Pod::Coverage';
test_requires 'Test::Perl::Critic';
test_requires 'Test::mysqld';
test_requires 'Test::postgresql';
test_requires 'Devel::Cover';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
