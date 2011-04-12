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
            table   => 'Game',
            attr    => {
                prefetch => [qw/ home_team away_team /],
            }
        };


    while (my $line = <$fh>) {
        given ($line) {

            when (m{<h1>\s+(\d{4})\s+Season Scores and Results</h1>}) {
                $season = $1;
            }

            when (m{^<table\s+.*<b>.*?Round\s+(\d+)</td>}) {
                $round = $1;
                $game = { search => { season => $season, round => $round } };
            }

            when (m{Venue:}) {
                parse_home_game_line($game, $line);
            }

            when (m{^<tr.*<a href="../teams/.*?.html">(.*?)</a>.*Bye}) {
                # nothing
            }

            when (m{^<tr.*<a\shref="../teams/.*?.html">(.*?)</a>
                     .*?(\d+)\.(\d+)\)?\s+</tt>}x) {

                $game->{search}->{'away_team.name'}  = fix_team($1);
                $game->{update}->{away_team_goals}   = $2;
                $game->{update}->{away_team_behinds} = $3;
                $game->{update}->{has_ended}         = 1;

                push(@{ $yaml->{update} }, $game);
                #print Dump($game);
                $game = { search => { season => $season, round => $round } };
            }
        }
    }

    return $yaml;
}

sub parse_home_game_line {
    my ($game, $line) = @_;

    my ($team) = ($line =~ m{<a href="../teams/.*?\.html">(.*?)</a>});
    my ($goals, $behinds) = ($line =~ m{(\d+)\.(\d+)\)?\s+</tt>});

    $game->{search}->{'home_team.name'}  = fix_team($team);
    $game->{update}->{home_team_goals}   = $goals;
    $game->{update}->{home_team_behinds} = $behinds;
}

my $year = DateTime->now->year;
my $url = "http://stats.rleague.com/afl/seas/$year.html";
my $fh = IO::String->new(WWW::Mechanize->new->get($url)->content);
my $yaml = parse_file($fh);

print Dump($yaml);