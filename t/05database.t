#!/usr/bin/env perl

use Modern::Perl;

use FindBin ();
use lib "$FindBin::Bin";

use Test::Most;
use Tipping::Config;
use Tipping::Schema;
use Tipping::DeploymentHandler;
use Test::Tipping::Database;

$ENV{PATH} .= ':/usr/sbin';

my @db_drivers = qw/ Pg SQLite mysql /;
my $db_driver = $ENV{TIPPING_DB_DRIVER} // $db_drivers[1];

Test::Tipping::Database::install($db_driver, Tipping::Config->config);

plan tests => 1;

lives_ok { Tipping::DeploymentHandler->new->update } 'Deploy database';

my $schema = Tipping::Schema->connect;
my $games = $schema->resultset('Game');

diag('Round 3');
print_games(scalar $games->search(
    {
        round => 3,
    },
    {
        prefetch => [qw/ home_team away_team venue /],
    }
));

diag('Hawthorn games');
print_games(scalar $games->search(
    {
        -or => [
            { 'home_team.name' => 'Hawthorn' },
            { 'away_team.name' => 'Hawthorn' },
        ]
    },
    {
        prefetch => [qw/ home_team away_team venue /],
    }
));

diag "Exiting";

sub get_preffered_venue_name {
    my $venue = shift;

    my $this = 2011;
    my $sponsor = $venue->sponsor_names->find({
            start_year => [
                { '<=' => $this },
                { '='  => undef },
            ],
            end_year => [
                { '>=' => $this },
                { '='  => undef },
            ]
        });

    return ($sponsor // $venue)->name;
}

sub print_games {
    my $resultset = shift;
    while (my $game = $resultset->next) {
        my $localtime = $game->start_time_utc->clone();
        $localtime->set_time_zone($game->venue->time_zone);
        diag "Round " . $game->round . " " .
             $game->home_team->nickname . " vs " .
             $game->away_team->nickname . " at " .
             get_preffered_venue_name($game->venue) . " ",
             $localtime->strftime('%A %B %e%l:%M%P') .
             " (" . $game->venue->time_zone . ')';
    }
}
