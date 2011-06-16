#!/usr/bin/env perl

use Modern::Perl::5_14;

use FindBin ();
use lib "$FindBin::Bin";

use Data::Dumper::Concise;
use Try::Tiny;

use Test::Most;
use Tipping::Config;
use Tipping::Schema;
use Tipping::DeploymentHandler;
use Test::Tipping::Database;
use Test::Tipping::Fixtures;

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
my $fixtures = Test::Tipping::Fixtures->new(schema => $schema);

my $games = $schema->resultset('Game');
my $venues = $schema->resultset('Venue');
my $comps = $schema->resultset('Competition');
my $users = $schema->resultset('User');
my $teams = $schema->resultset('Team');
my $memberships = $schema->resultset('Membership');

is($games->count, 187, '187 games');
is($games->search_related('game_teams', {},
    { prefetch => 'team', group_by => 'team.name' })->count, 17, 'Seventeen teams');

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


my $game_teams = $schema->resultset('Game_Team');
$rs = $game_teams->search(
        {
            'team.name'    => 'Hawthorn',
            'venue.name'   => 'MCG',
            'is_home_team' => 1,
        },
        {
            prefetch => [qw/ team game /, { game => 'venue' } ],
        }
    );
is($rs->count, 7, 'Seven Hawthorn games at the MCG');

my $mcg = $venues->find({name => 'MCG'});
is($mcg->sponsor_name(2011), undef, 'No sponsor name for MCG');

my $docklands = $venues->find({ name => { 'like' => '%Docklands%' }});
is($docklands->sponsor_name(2011), 'Etihad Stadium', 'Docklands Stadium is Etihad Stadium in 2011');
is($docklands->sponsor_name(2008), 'Telstra Dome', 'Docklands Stadium was Telstra Dome in 2008');

my $membership_count = $memberships->count;

my $num_comps = 3;
my @comps = map { $fixtures->competition(name => "comp$_") } (1 .. $num_comps);

my $num_users = 10;
my @user_list = map {
        $fixtures->user(username => "user$_", competitions => \@comps )
    } (1 .. $num_users);

is($memberships->count, $membership_count + $num_users * $num_comps);

is($users->find({ username => 'user1' })
         ->competitions->search({ name => [qw/comp1 comp2/]})->count, 2);

# These next three generate the same SQL
is($users->search(
            {
                username => 'user1',
                'competition.name' => [qw/comp1 comp2/],
            },
            {
                join => { memberships => 'competition' },
            })->count, 2);

is($users->search({ username => 'user1' })
         ->search_related('memberships',
            {
                'competition.name' => [qw/comp1 comp2/]
            },
            {
                join => [qw/ competition /],
            })->count, 2);

is($users->search({ username => 'user1' })
         ->search_related('memberships')
         ->search_related('competition', { 'name' => [qw/comp1 comp2/] })
         ->count, 2);

while (@comps) {
    my $comp = shift @comps;
    $comp->delete;
    is(scalar $user_list[0]->competitions, --$num_comps);
}
$teams->find( { name => 'Hawthorn' } )->add_to_supporters({supporter => $user_list[0]});
is($user_list[0]->team->team->name, 'Hawthorn');
#$user_list[0]->team({ team => $teams->find( { name => 'Hawthorn' } ) });

my $finished_games = $game_teams->search(
    {
        'game.round' => { '<=' => 3 },
        'game.has_ended' => 1,
    },
    {
        prefetch => [qw/ game /],
    }
);
is($finished_games->count, 3 * 8 * 2, 'Completed 4 rounds, 8 games, 2 teams');

my $round1_expected = [
    [ 'Carlton',     'Richmond',         'MCG' ],
    [ 'Geelong',     'St Kilda',         'MCG' ],
    [ 'Collingwood', 'Port Adelaide',    'Docklands Stadium' ],
    [ 'Brisbane',    'Fremantle',        'Gabba' ],
    [ 'Adelaide',    'Hawthorn',         'Football Park' ],
    [ 'Essendon',    'Western Bulldogs', 'Docklands Stadium' ],
    [ 'Melbourne',   'Sydney',           'MCG' ],
    [ 'West Coast',  'North Melbourne',  'Subiaco Oval' ],
];
my @round1_got = ();
my $round1_rs = $games->round(1)->with_teams;
while (my $game = $round1_rs->next) {
    push(@round1_got, [
            $game->home->team->name,
            $game->away->team->name,
            $game->venue->name,
        ]);
}
eq_or_diff($round1_expected, \@round1_got, 'Round 1 2011 is correct');

=pod
sub compute_ladder {
    my $rs = $game_teams->search(
            {
                'game.has_ended' => 1,
            },
            {
                prefetch => [qw/ team game      /],
                order_by => [qw/ me.game_id     /],
            }
        );

    my (%played, %points_for, %points_against, %premiership_points);

    while (my $home = $rs->next) {
        my $away = $rs->next;

        for my $a ($home, $away) {

            my $b = ($a == $home) ? $away : $home;
            my $name = $a->team->name;

            $played{$name}++;
            $points_for{$name}         += $a->score;
            $points_against{$name}     += $b->score;
            $premiership_points{$name} += 2 * ( $a->score >  $b->score );
            $premiership_points{$name} += 2 * ( $a->score >= $b->score );
        }
    }

    say STDERR "";

    my %percentage = map { $_ => 100 * $points_for{$_} / $points_against{$_} }
                     keys %played;

    my @ladder = reverse sort {
        ($premiership_points{$a} <=> $premiership_points{$b}) ||
        ($percentage{$a} <=> $percentage{$b})
    } keys %played;

    for my $team (@ladder) {
        say STDERR sprintf('%-16s %2d %5.1f%%',
            $team, $premiership_points{$team}, $percentage{$team});
    }
}

&compute_ladder;
=cut

done_testing();
