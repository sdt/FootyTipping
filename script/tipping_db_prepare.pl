#!/usr/bin/env perl

use Modern::Perl::5_14;
use autodie;

use Tipping::DeploymentHandler;

my $dh = Tipping::DeploymentHandler->new;
$dh->prepare;
