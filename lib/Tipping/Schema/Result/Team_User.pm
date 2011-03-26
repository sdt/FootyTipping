package Tipping::Schema::Result::Team_User;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('team_user');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
    team_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ user_id team_id /);

# no more than one team per user
__PACKAGE__->add_unique_constraint([ qw/ user_id / ]);

__PACKAGE__->belongs_to(
    user => 'Tipping::Schema::Result::User',
    'user_id'
);
__PACKAGE__->belongs_to(
    team => 'Tipping::Schema::Result::Team',
    'team_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Competition_User - Schema table representing optional one-to-one relationship between users and teams. A user might have a team.

=cut
