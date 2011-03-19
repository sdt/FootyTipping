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
    default             => 0,
};

__PACKAGE__->load_components(qw/Core InflateColumn::DateTime/);
__PACKAGE__->table('game');
__PACKAGE__->add_columns(
    round        => {
        data_type   => 'integer',
        is_nullable => 0,
    },

    home_team_id => $foreign_key,
    away_team_id => $foreign_key,

    venue_id     => $foreign_key,
    start_time => {
        data_type   => 'timestamp with time zone',
        is_nullable => 0,
    },

    home_team_goals   => $score,
    home_team_behinds => $score,

    away_team_goals   => $score,
    away_team_behinds => $score,
);

__PACKAGE__->set_primary_key(qw/ venue_id start_time /);

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

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game

=cut
