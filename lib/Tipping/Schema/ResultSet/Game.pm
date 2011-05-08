package Tipping::Schema::ResultSet::Game;
use parent 'DBIx::Class::ResultSet';

use Modern::Perl;

sub round {
    my ($self, $round) = @_;
    return $self->search({ round => $round });
}

sub inflate_games {
    my ($self) = @_;
    return $self->search(
        {
            'home.is_home_team' => 1,
            'away.is_home_team' => 0,
        },
        {
            prefetch => [qw/ venue /, { home => 'team' }, { away => 'team' }],
            join     => [qw/ venue home away /],
            order_by => [qw/ me.start_time_utc venue.name /],
        },
    );
}

sub has_ended {
    my ($self, $has_ended) = @_;
    return $self->search({ has_ended => $has_ended });
}

sub all_ended {
    my ($self) = @_;
    return $self->has_ended(0)->count == 0;
}

sub rounds {
    my ($self) = @_;

    return $self->search(undef,
        {
            order_by => [qw/ round /],
            distinct => 1,
        },
    )->get_column('round')->all;
}

sub current_round {
    my ($self) = @_;

    my $now = DateTime->now;

    my $next_game = $self->search(
        {
            start_time_utc => { '>=', $now }
        },
        {
            columns => [qw/ round /],
            order_by => { '-asc' => 'start_time_utc' },
            rows => 1,
        }
    )->first;
    return $next_game->round if $next_game;

    my $final_game = $self->search(undef,
        {
            columns => [qw/ round /],
            order_by => { '-desc' => 'start_time_utc' },
            rows => 1,
        }
    )->first;
    return $final_game->round;
}

1;

=pod

=head1 NAME

Tipping::Schema::ResultSet::Game - DBIx::Class ResultSet class

=head1 DESCRIPTION

Pre-defined game searches.

=head1 METHODS

=head2 round ($round)

Filter the game table by round.

=head2 inflate_games

Do the necessary joins and prefetches to get the home and away teams included.
Populates the home and away relationships on game.

=head2 team ($team_name)

Filter the game table by team name - finds both home and away games.

=head2 has_ended ($bool)

Filter the game table by games which have ended (or not).

=head2 all_ended

Determine whether all the games in the current resultset have ended.

=head2 rounds

Returns a list of the rounds for this season

=head2 current_round

Find the current round.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
