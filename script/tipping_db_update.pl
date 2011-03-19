#!/usr/bin/env perl

use Modern::Perl;
use autodie;

use Tipping::Config;
use Tipping::Schema;
use Tipping::DeploymentHandler;

my $schema = Tipping::Schema->connect(Tipping::Config->config->{database});
my $dh = Tipping::DeploymentHandler->new(schema => $schema);
$dh->update;
