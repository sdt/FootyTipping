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

plan tests => 10;

lives_ok { Tipping::DeploymentHandler->new->update } 'Deploy database';

my $schema = Tipping::Schema->connect;
my $games = $schema->resultset('Game')->season(2011);
my $venues = $schema->resultset('Venue');
my $comps = $schema->resultset('Competition');
my $users = $schema->resultset('User');

my $venue_prefetch = { prefetch => [qw/ venue /] };

is($games->count, 187, '187 games in 2011');
is($games->search({}, { group_by => 'home_team_id' })->count, 17, '17 teams');

sub teams {
    my ($games, $home_or_away) = @_;
    return [ $games->search(undef,
            {   group_by => "$home_or_away.name",
                prefetch => $home_or_away
            },
        )->get_column("$home_or_away.name")->all ];
}
eq_or_diff(teams($games, 'home_team'), teams($games, 'away_team'),
          'Home teams and away teams match');

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

my $num_comps = 3;
for my $id (1 .. $num_comps) {
    $comps->create({
            name => "comp$id",
        });
}

my $num_users = 10;
for my $id (1 .. $num_users) {
    my $user = $users->create({
        user_name => "user$id",
        real_name => "User $id",
        email     => "user$id\@nftatips.org",
        password  => "pass$id",
    });

    for my $compid (1 .. $num_comps) {
        $user->add_to_competitions($comps->find({ name => "comp$compid" }));
    }
}
