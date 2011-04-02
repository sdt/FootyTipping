#!/usr/bin/env perl
use Modern::Perl;
use autodie;
use YAML;

# Historical data files grabbed from:
#  http://stats.rleague.com/afl/seas/season_idx.html

sub parse_file {
    my ($filename) = @_;

    my ($season, $round, $game);

    open my $fh, '<', $filename;
    while (my $line = <$fh>) {
        given ($line) {

            when (m{<h1>\s+(\d{4})\s+Season Scores and Results</h1>}) {
                $season = $1;
            }

            when (m{^<table\s+.*<b>(.*?Final.*?|Round \d+)</td>}) {
                $round = $1;
                $game = { season => $season, round => $round };
            }

            when (m{Venue:}) {
                parse_home_game_line($game, $line);
            }

            when (m{^<tr.*<a href="../teams/.*?.html">(.*?)</a>.*Bye}) {
                # nothing
            }

            when (m{^<tr.*<a\shref="../teams/.*?.html">(.*?)</a>
                     .*?(\d+)\.(\d+)\)?\s+</tt>}x) {

                $game->{away_team}    = $1;
                $game->{away_goals}   = $2;
                $game->{away_behinds} = $3;

                print Dump($game);
                die unless $game->{venue};
                $game = { season => $season, round => $round };
            }

        }
    }
    close $fh;
}

sub parse_home_game_line {
    my ($game, $line) = @_;

    my ($team) = ($line =~ m{<a href="../teams/.*?\.html">(.*?)</a>});
    my ($goals, $behinds) = ($line =~ m{(\d+)\.(\d+)\)?\s+</tt>});
    my ($date) = ($line =~ m{(\d+-[A-Z][a-z]+-\d\d\d\d)});
    my ($venue) = ($line =~ m{<a\shref="../venues/.*?.html">(.*?)</a>});

    my $time;
    if ($line =~ m{\d+:\d+\s+[AP]M\s+\((\d+:\d+\s+[AP]M)\)}) {
        $time = $1;
    }
    elsif ($line =~ m{(\d+:\d+\s+[AP]M)}) {
        $time = $1;
    }
    else {
        die $line;
    }

    $game->{home_team}    = $team;
    $game->{home_goals}   = $goals;
    $game->{home_behinds} = $behinds;
    $game->{date}         = $date;
    $game->{time_est}     = $time;
    $game->{venue}        = $venue;
}

parse_file($_) for (<*.html>);
