package Tipping::Schema::Result::Team;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('team');
__PACKAGE__->add_columns(
    team_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },
    name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    nickname => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key('team_id');

__PACKAGE__->add_unique_constraint([ qw/ name / ]);
__PACKAGE__->add_unique_constraint([ qw/ nickname / ]);

__PACKAGE__->has_many(
    home_games => 'Tipping::Schema::Result::Game',
    'home_team_id',
);
__PACKAGE__->has_many(
    away_games => 'Tipping::Schema::Result::Game',
    'away_team_id',
);
__PACKAGE__->has_many(
    games => 'Tipping::Schema::Result::Game',
    [ { 'foreign_key.home_team_id' => 'self.team_id' },
      { 'foreign_key.away_team_id' => 'self.team_id' } ]
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Team - Schema table representing teams

=cut
