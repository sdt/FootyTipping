#!/usr/bin/env perl

use Modern::Perl;
use autodie;

use Tipping::DeploymentHandler;

my $dh = Tipping::DeploymentHandler->new;
$dh->prepare;
