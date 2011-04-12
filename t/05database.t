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

#plan tests => 10;

lives_ok { Tipping::DeploymentHandler->new->update } 'Deploy database';

my $schema = Tipping::Schema->connect;
my $games = $schema->resultset('Game')->season(2011);
my $venues = $schema->resultset('Venue');
my $comps = $schema->resultset('Competition');
my $users = $schema->resultset('User');

is($games->count, 187, '187 games in 2011');
is($games->search_related('game_teams', {},
    { prefetch => 'team', group_by => 'team.name' })->count, 17, '17 teams');

is($games->round(3)->count, 8, 'Eight games in round 3');

my $rs = $games->round(3)->search(undef,
    {
        join     => [qw/ game_teams /],
        group_by => [qw/ game_teams.team_id /],
    }
);
is($rs->count, 16, 'Sixteen teams in round 3');

=pod Print out the fixture for round 3
$rs = $games->round(3)->search(undef,
    {
        prefetch => [qw/ game_teams /],
        group_by => [qw/ game_teams.team_id /],
    }
);
while (my $row = $rs->next) {
    my $teams = $row->teams->search({},
            { order_by => { '-desc' => 'is_home_team' } }
        );
    say STDERR join(' vs ', $teams->get_column('name')->all);
}
=cut

=pod

my @hfcggames = $games->team('Hawthorn')->search(undef,
    { prefetch => [qw/ venue /] });
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

my $home_team_winners = $games->has_ended(1)->search(
        {
            home_team_goals => { '>' =>
                \'(away_team_goals*6 + away_team_behinds - home_team_behinds)/6'
            },
        },
        {
            '+select' => [ 'home_team.name', { count => '*'} ],
            '+as'     => [qw/ winner  num_wins /],
            prefetch  => [qw/ home_team      /],
            group_by  => [qw/ home_team_id /],
            order_by  => [ { -desc => [qw/ num_wins /] } ],
        },
    );
while (my $game = $home_team_winners->next) {
    say STDERR $game->get_column('winner'), ' ', $game->get_column('num_wins');
}
=cut

done_testing();
