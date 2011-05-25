package Tipping::Schema::ResultSet::Game;
use parent 'Tipping::Schema::ResultSet';

use Modern::Perl::5_14;

sub round {
    my ($self, $round) = @_;
    return $self->search({ round => $round });
}

sub with_teams {
    my ($self) = @_;
    return $self->search(
        {
            'home.is_home_team' => 1,
            'away.is_home_team' => 0,
        },
        {
            prefetch => [qw/ venue /, { home => 'team' }, { away => 'team' }],
            order_by => [qw/ me.start_time_utc venue.name /],
        },
    );
}

sub have_started {
    my ($self, $has_started) = @_;
    my $now = DateTime->now( time_zone => 'UTC' );
    my $op = $has_started ? '<=' : '>';
    return $self->search({ start_time_utc => { $op => $now } });
}

sub all_started {
    my ($self) = @_;
    return $self->have_started(0)->count == 0;
}

sub have_ended {
    my ($self, $has_ended) = @_;
    return $self->search({ has_ended => $has_ended });
}

sub all_ended {
    my ($self) = @_;
    return $self->have_ended(0)->count == 0;
}

sub rounds {
    my ($self) = @_;

    # Cache this list - it won't be changing mid-season.
    state $rounds = [ $self->search(undef,
            {
                order_by => [qw/ round /],
                distinct => 1,
            }
        )->get_column('round')->all ];
    return @{ $rounds };
}

sub current_round {
    my ($self) = @_;

    #TODO: Subtracting three hours from now is a bit of a hack meaning we
    #      consider a game must have finished three hours after it started.
    my $now = DateTime->now( time_zone => 'UTC' )->subtract( hours => 3 );
    $now = DateTime->new( time_zone => 'UTC', year=>2011, month=>11);

    my $next_game = $self->search(
        {
            start_time_utc => { '>=', $now }
        },
        {
            columns => [qw/ round /],
            order_by => { '-asc' => 'start_time_utc' },
            rows => 1,
        }
    )->single;
    return $next_game ? $next_game->round : scalar($self->rounds);
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

=head2 with_teams

Do the necessary joins and prefetches to get the home and away teams included.
Populates the home and away relationships on game.

=head2 team ($team_name)

Filter the game table by team name - finds both home and away games.

=head2 have_started ($bool)

Filter the game table by games which have started (or not).

=head2 all_started

Determine whether all the games in the current resultset have started.

=head2 have_ended ($bool)

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
