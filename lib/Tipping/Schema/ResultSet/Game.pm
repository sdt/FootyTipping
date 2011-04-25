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

sub games {
    my ($self) = @_;
    return $self->search(
        {
            'home.is_home_team' => 1,
            'away.is_home_team' => 0,
        },
        {
            prefetch => [qw/ venue /, { home => 'team' }, { away => 'team' }],
            join     => [qw/ venue home away /],
            order_by => [qw/ me.start_time_utc /],
        },
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

=head2 games

Do the necessary joins and prefetches to get the home and away teams included.
Populates the home and away relationships on game.

=head2 team ($team_name)

Filter the game table by team name - finds both home and away games.

=head2 has_ended ($bool)

Filter the game table by games which have ended (or not).

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
