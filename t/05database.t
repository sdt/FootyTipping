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
            'game.season'  => 2011,
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

=pod
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
=cut

my $finished_games = $game_teams->search(
    {
        'game.has_ended' => 1,
    },
    {
        prefetch => [qw/ game /],
    }
);
is($finished_games->count, 3 * 8 * 2, 'Completed 3 rounds, 8 games, 2 teams');

my $inject_scores = $finished_games->search(undef,
    {
        '+select' => [ { max => \'goals * 6 + behinds', -as => 'points' } ],
        '+as'     => [qw/ score /],
        group_by => [qw/ me.game_id me.team_id /],
    }
);
is($inject_scores->count, 3 * 8 * 2, 'Completed 3 rounds, 8 games, 2 teams');

sub compute_ladder {
    my $rs = $game_teams->search(
            {
                season           => 2011,
                'game.has_ended' => 1,
            },
            {
                prefetch => [qw/ team game      /],
                order_by => [qw/ me.game_id     /],
            }
        );

    my (%played, %points_for, %points_against, %premiership_points, %opponent);
    while (my $game_team = $rs->next) {

        $points_for{$game_team->team->name} += $game_team->score;
        $played{$game_team->team->name}++;

        my $opp_team = delete $opponent{$game_team->game->game_id};

        if (defined $opp_team) {
            $points_against{$game_team->team->name} += $opp_team->score;
            $points_against{$opp_team->team->name} += $game_team->score;

            if ($game_team->score > $opp_team->score) {
                $premiership_points{$game_team->team->name} += 4;
            }
            elsif ($game_team->score < $opp_team->score) {
                $premiership_points{$opp_team->team->name}  += 4;
            }
            else {
                $premiership_points{$game_team->team->name} += 2;
                $premiership_points{$opp_team->team->name}  += 2;
            }
        }
        else {
            $opponent{$game_team->game->game_id} = $game_team;
            die if scalar keys %opponent > 1;
        }
    }

    say STDERR "";

    my %percentage;
    for my $team (keys %points_for) {
        $percentage{$team} = 100 * $points_for{$team} / $points_against{$team};
        $premiership_points{$team} //= 0;
    }

    my @ladder = reverse sort {
        ($premiership_points{$a} <=> $premiership_points{$b}) ||
        ($percentage{$a} <=> $percentage{$b})
    } keys %points_for;

    for my $team (@ladder) {
        printf STDERR ("%-16s %2d %5.1f%%\n", $team, $premiership_points{$team}, $percentage{$team});
    }
}

&compute_ladder;

=pod Trying to figure out how to compute a ladder
my $winners = $inject_scores->search({},
    {
        '+select' => [ { max => 'goals' } ],
        '+as'     => [qw/ max_goals /],
        group_by => [qw/ me.game_id /],
        prefetch => [qw/ team /],
    },
);
while (my $row = $winners->next) {
    say STDERR join(" ", $row->team->name, $row->goals, $row->behinds, $row->score, 'max:', $row->get_column('max_goals'));
}
=cut

done_testing();
