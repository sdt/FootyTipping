#!/usr/bin/env perl
# IMPORTANT: if you delete this file your app will not work as
# expected.  You have been warned.
use inc::Module::Install;
use Module::Install::Catalyst; # Complain loudly if you don't have
                               # Catalyst::Devel installed or haven't said
                               # 'make dist' to create a standalone tarball.

name 'Tipping';
all_from 'lib/Tipping/WebApp.pm';

requires 'Catalyst::Runtime' => '5.80032';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';

requires 'Carp';
requires 'Config::JFDI';
requires 'Data::Dumper::Concise';
requires 'DBIx::Class::DeploymentHandler';
requires 'File::ShareDir';
requires 'List::MoreUtils';
requires 'Modern::Perl';
requires 'Moose';
requires 'namespace::autoclean';
requires 'Params::Validate';
requires 'SQL::Translator';
requires 'YAML::XS';

test_requires 'Test::More' => '0.88';
test_requires 'Test::Most';
test_requires 'Test::Perl::Critic';
test_requires 'Test::Pod';

test_requires 'Carp';
test_requires 'Catalyst::Test';
test_requires 'File::Find';
test_requires 'FindBin';
test_requires 'Modern::Perl';
test_requires 'Pod::Coverage';

catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
