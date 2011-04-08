#!/usr/bin/env perl

use Modern::Perl;

use FindBin ();
use lib "$FindBin::Bin";

use Data::Dumper::Concise;
use Try::Tiny;

use Test::Most;
use Tipping::Config;
use Tipping::Schema;
use Tipping::DeploymentHandler;
use Test::Tipping::Database;

my @db_drivers = qw/ Pg SQLite mysql /;
my $db_driver = $ENV{TIPPING_DB_DRIVER} // $db_drivers[1];
try {
    Test::Tipping::Database::install($db_driver, Tipping::Config->config);
}
catch {
    plan skip_all => $_;
};

plan tests => 7;

lives_ok { Tipping::DeploymentHandler->new->update } 'Deploy database';

my $schema = Tipping::Schema->connect;
my $games = $schema->resultset('Game')->season(2011);
my $venues = $schema->resultset('Venue');

my $venue_prefetch = { prefetch => [qw/ venue /] };

my @round3 = $games->round(3)->search(undef, $venue_prefetch);
is(scalar @round3, 8, 'Eight games in round 3');

my %teams;
for my $game (@round3) {
    $teams{$game->home_team->name}++;
    $teams{$game->away_team->name}++;
}
is(scalar keys %teams, 16, 'Sixteen teams in round 3');

my @hfcggames = $games->team('Hawthorn')->search(undef, $venue_prefetch);
is(scalar @hfcggames, 22, 'Twenty-two Hawthorn games');

my $mcg = $venues->find({name => 'MCG'});
is($mcg->sponsor_name(2011), undef, 'No sponsor name for MCG');

my $docklands = $venues->find({ name => { 'like' => '%Docklands%' }});
is($docklands->sponsor_name(2011), 'Etihad Stadium', 'Docklands Stadium is Etihad Stadium in 2011');
is($docklands->sponsor_name(2008), 'Telstra Dome', 'Docklands Stadium is Telstra Dome in 2008');
