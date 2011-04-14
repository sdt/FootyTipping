package Tipping::Schema::Result::Game_Team;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tbl_game_team');

my %column_type = (

    foreign_key => {
        data_type           => 'integer',
        is_nullable         => 0,
    },

    boolean => {
        data_type           => 'boolean',
        is_nullable         => 0
    },

    score => {
        data_type           => 'integer',
        is_nullable         => 0,
        default_value       => 0,
    },
);

my %columns = qw(
    game_id         foreign_key
    team_id         foreign_key
    is_home_team    boolean
    goals           score
    behinds         score
);
while (my ($name, $type) = each %columns) {
    __PACKAGE__->add_column($name => $column_type{$type});
}

__PACKAGE__->set_primary_key(qw/ game_id team_id /);

__PACKAGE__->add_unique_constraint([qw/ game_id is_home_team /]);

__PACKAGE__->belongs_to(
    game => 'Tipping::Schema::Result::Game',
    'game_id'
);
__PACKAGE__->belongs_to(
    team => 'Tipping::Schema::Result::Team',
    'team_id'
);

sub score {
    my ($self) = @_;
    return $self->goals * 6 + $self->behinds;
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game_Team - DBIx::Class result source

=head1 DESCRIPTION

A team plays in many games. A game has two teams.

This is a many-to-many relationship between teams and games.

By setting the primary key to game_id and team_id, we ensure the same team
can only participate once in a match. The unique constraint on game_id and
is_home_team limits the number of teams per game to two.

There is nothing to prevent only one team in a game. This leaves open the
possibility of directly representing byes.

Originally the game table held two team_id fields, but this caused overly
cumbersome queries.

=head1 METHODS

=head2 score

Computes the total score from goals and behinds

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
