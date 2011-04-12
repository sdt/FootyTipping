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

sub team {
    my ($self, $team) = @_;
    return $self->search(
            { 'team.name' => $team },
            { prefetch => [qw/ team /] },
        );
}

sub has_ended {
    my ($self, $has_ended) = @_;
    return $self->search({ has_ended => $has_ended });
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
