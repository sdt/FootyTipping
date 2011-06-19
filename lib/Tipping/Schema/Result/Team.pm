package Tipping::Schema::Result::Team;
use parent 'Tipping::Schema::Result';

use Modern::Perl::5_14;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tbl_team');
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
    game_teams => 'Tipping::Schema::Result::Game_Team',
    'team_id',
);
__PACKAGE__->many_to_many(
    games => 'game_teams',
    'game',
);

__PACKAGE__->has_many(
    supporters => 'Tipping::Schema::Result::User',
    'team_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Team - DBIx::Class

=head1 DESCRIPTION

A team has a name and a nickname, and zero or more supporters.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
