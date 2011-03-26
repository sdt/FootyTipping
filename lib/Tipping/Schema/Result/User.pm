package Tipping::Schema::Result::User;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },
    user_name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    real_name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    screen_name => {
        data_type           => 'varchar',
        is_nullable         => 1,
    },
    password => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key('user_id');

__PACKAGE__->add_unique_constraint([ qw/ user_name / ]);
__PACKAGE__->add_unique_constraint([ qw/ real_name / ]);
__PACKAGE__->add_unique_constraint([ qw/ screen_name / ]);

__PACKAGE__->has_many(
    tips => 'Tipping::Schema::Result::Tip',
    'user_id'
);
__PACKAGE__->has_many(
    competition_users => 'Tipping::Schema::Result::Competition_User',
    'user_id'
);
__PACKAGE__->many_to_many(
    competitions => 'competition_users',
    'competition_id'
);

__PACKAGE__->might_have(
    team => 'Tipping::Schema::Result::Team_User',
    'user_id'
);


1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Competition - Schema table representing tipping competitions

=cut
