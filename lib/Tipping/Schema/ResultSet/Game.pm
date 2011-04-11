package Tipping::Schema::ResultSet::Game;
use parent 'DBIx::Class::ResultSet';

use Modern::Perl;

sub season {
    my ($self, $season) = @_;
    return $self->search({ season => $season });
}

sub round {
    my ($self, $round) = @_;
    return $self->search({ round => $round });
}

sub home_team {
    my ($self, $home_team) = @_;
    return $self->search(
            { 'home_team.name' => $home_team },
            { prefetch => [qw/ home_team /] },
        );
}

sub team {
    my ($self, $team) = @_;
    return $self->search(
            { -or => [
                { 'home_team.name' => $team },
                { 'away_team.name' => $team },
              ],
            },
            { prefetch => [qw/ home_team away_team /] },
        );
}

sub has_ended {
    my ($self, $has_ended) = @_;
    return $self->search({ has_ended => $has_ended });
}

sub with_scores {
    my ($self) = @_;
    # TODO: add { -as => 'home_team_score' } into the +select line somehow
    # http://search.cpan.org/~abraxxa/DBIx-Class-0.08127/lib/DBIx/Class/ResultSet.pm#select
    return $self->search(undef,
        {
            '+select' => [
               'home_team_goals * 6 + home_team_behinds',
               'away_team_goals * 6 + away_team_behinds',
            ],
            '+as' => [qw/ home_team_score away_team_score /],
        }
    );
}

1;

=pod

=head1 NAME

Tipping::Schema::ResultSet::Game - DBIx::Class ResultSet class

=head1 DESCRIPTION

Pre-defined gam searches. Really just a proof-of-concept to see what's possible.

=head1 METHODS

=head2 season ($season)

Filter the game table by season.

=head2 round ($round)

Filter the game table by round.

=head2 home_team ($home_team_name)

Filter the game table by home team's name.

=head2 team ($team_name)

Filter the game table by team name - finds both home and away games.

=head2 has_ended ($bool)

Filter the game table by games which have ended (or not).

=head2 with_scores ()

Injects two extra virtual columns into the resultset - home_team_score and
away_team_score.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
