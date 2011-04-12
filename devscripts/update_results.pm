#!/usr/bin/env perl
use Modern::Perl;

use autodie;
use DateTime;
use IO::String;
use WWW::Mechanize;
use YAML;

# Historical data files grabbed from:
#  http://stats.rleague.com/afl/seas/season_idx.html

sub fix_team {
    my ($team) = @_;

    given ($team) {
        when ('Brisbane Lions') { $team = 'Brisbane' };
    }

    return $team;
}

sub parse_file {
    my ($fh) = @_;

    my ($season, $round, $game);
    my $yaml = {
            table   => 'Game_Team',
            attr    => {
                prefetch => [qw/ team game /],
            }
        };


    while (my $line = <$fh>) {
        given ($line) {

            when (m{<h1>\s+(\d{4})\s+Season Scores and Results</h1>}) {
                $season = $1;
            }

            when (m{^<table\s+.*<b>.*?Round\s+(\d+)</td>}) {
                $round = $1;
                $game = { search =>
                        { 'game.season' => $season, 'game.round' => $round }
                    };
            }

            when (m{^<tr.*<a href="../teams/.*?.html">(.*?)</a>.*Bye}) {
                # nothing
            }

            when (m{^<tr.*<a\shref="../teams/.*?.html">(.*?)</a>
                     .*?(\d+)\.(\d+)\)?\s+</tt>}x) {

                $game->{search}->{'team.name'}  = fix_team($1);
                $game->{update}->{goals}   = $2;
                $game->{update}->{behinds} = $3;
                #$game->{update}->{has_ended}         = 1;

                push(@{ $yaml->{update} }, $game);
                $game = {
                    search => {
                        'game.season' => $season,
                        'game.round' => $round,
                    },
                    update_related => {
                        relation => 'game',
                        values => { has_ended => 1 },
                    },
                };
            }
        }
    }

    return $yaml;
}

my $year = DateTime->now->year;
my $url = "http://stats.rleague.com/afl/seas/$year.html";
my $fh = IO::String->new(WWW::Mechanize->new->get($url)->content);
my $yaml = parse_file($fh);

print Dump($yaml);
