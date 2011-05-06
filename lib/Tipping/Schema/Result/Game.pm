package Tipping::Schema::Result::Game;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components(qw/Core InflateColumn::DateTime/);
__PACKAGE__->table('tbl_game');
__PACKAGE__->add_columns(
    game_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },
    round => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
    venue_id => {
        data_type           => "integer",
        is_nullable         => 0,
    },
    start_time_utc => {
        data_type           => 'datetime',
        is_nullable         => 0,
    },
    has_ended   => {
        data_type           => 'boolean',
        is_nullable         => 0,
        default_value       => 0,
    },
);

__PACKAGE__->set_primary_key('game_id');

# TODO: for round 24 the time isn't decided until after round 23
# Need some way to make those unique
#__PACKAGE__->add_unique_constraint([qw/ round venue_id start_time_utc /]);

__PACKAGE__->belongs_to(
    venue => 'Tipping::Schema::Result::Venue',
    'venue_id'
);

__PACKAGE__->has_many(
    game_teams => 'Tipping::Schema::Result::Game_Team',
    'game_id'
);
__PACKAGE__->many_to_many(
    teams => 'game_teams',
    'team',
);

__PACKAGE__->has_many(
    tips => 'Tipping::Schema::Result::Tip',
    'game_id'
);

__PACKAGE__->has_one(
    home => 'Tipping::Schema::Result::Game_Team',
    'game_id',
    { where => { 'is_home_team' => 1 } },
);

__PACKAGE__->has_one(
    away => 'Tipping::Schema::Result::Game_Team',
    'game_id',
    { where => { 'is_home_team' => 0 } },
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game - DBIx::Class result source

=head1 DESCRIPTION

A game for a given round takes place between two teams at a venue at a given
start time. Once it has ended we flag it as such.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
