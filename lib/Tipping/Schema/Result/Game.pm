package Tipping::Schema::Result::Game;
use parent 'DBIx::Class';

use Modern::Perl;

my $foreign_key = {
    data_type           => "integer",
    is_nullable         => 0,
};
my $score = {
    data_type           => "integer",
    is_nullable         => 0,
    default_value       => 0,
};

__PACKAGE__->load_components(qw/Core InflateColumn::DateTime/);
__PACKAGE__->table('tbl_game');
__PACKAGE__->add_columns(
    game_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },

    season       => {
        data_type   => 'integer',
        is_nullable => 0,
    },
    round        => {
        data_type   => 'integer',
        is_nullable => 0,
    },

    home_team_id => $foreign_key,
    away_team_id => $foreign_key,

    venue_id     => $foreign_key,

#    start_time_utc => {
#        data_type   => 'timestamp',
#        is_nullable => 0,
#    },

    home_team_goals   => $score,
    home_team_behinds => $score,

    away_team_goals   => $score,
    away_team_behinds => $score,

    has_ended   => {
        data_type     => 'boolean',
        is_nullable   => 0,
        default_value => 'false',
    },
);

__PACKAGE__->set_primary_key('game_id');

__PACKAGE__->add_unique_constraint([ qw/ season round home_team_id / ]);
__PACKAGE__->add_unique_constraint([ qw/ season round away_team_id / ]);

__PACKAGE__->belongs_to(
    home_team => 'Tipping::Schema::Result::Team',
    'home_team_id'
);
__PACKAGE__->belongs_to(
    away_team => 'Tipping::Schema::Result::Team',
    'away_team_id'
);
__PACKAGE__->belongs_to(
    venue => 'Tipping::Schema::Result::Venue',
    'venue_id'
);

__PACKAGE__->has_many(
    tips => 'Tipping::Schema::Result::Tip',
    'game_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game - DBIx::Class result source

=head1 DESCRIPTION

A game for a given round and season takes place between two teams at a venue
at a given start time.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
