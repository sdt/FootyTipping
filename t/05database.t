#!/usr/bin/env perl

use Modern::Perl;
use Test::Most;
use Tipping::Config;
use Tipping::Schema;
use Tipping::DeploymentHandler;
use Test::Tipping::Database;

$ENV{PATH} .= ':/usr/sbin';

my @db_drivers = qw/ Pg SQLite mysql /;
my $db_driver = $ENV{TIPPING_DB_DRIVER};

Test::Tipping::Database::install($db_driver, Tipping::Config->config);

plan tests => 1;

lives_ok { Tipping::DeploymentHandler->new->update } 'Deploy database';

my $schema = Tipping::Schema->instance;

diag('Round 3');
print_games(scalar $schema->resultset('Game')->search(
    {
        round => 3,
    },
    {
        prefetch => [qw/ home_team away_team venue /],
    }
));

diag('Hawthorn games');
print_games(scalar $schema->resultset('Game')->search(
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

Tipping::Schema->instance->storage->disconnect;
diag "Exiting";

sub print_games {
    my $resultset = shift;
    while (my $game = $resultset->next) {
        diag "Round " . $game->round . " " .
             $game->home_team->nickname . " vs " .
             $game->away_team->nickname . " at " .
             $game->venue->sponsor_name;
    }
}
