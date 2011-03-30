package Tipping::Schema::Result::Competition;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('competition');
__PACKAGE__->add_columns(
    competition_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },
    name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    password => {
        data_type           => 'varchar',
        is_nullable         => 1,
    },
);

__PACKAGE__->set_primary_key('competition_id');

__PACKAGE__->add_unique_constraint([ qw/ name / ]);

__PACKAGE__->has_many(
    competition_users => 'Tipping::Schema::Result::Competition_User',
    'competition_id'
);
__PACKAGE__->many_to_many(
    users => 'competition_users',
    'user_id'
);

__PACKAGE__->has_many(
    competition_admins => 'Tipping::Schema::Result::Competition_Admin',
    'competition_id'
);
__PACKAGE__->many_to_many(
    admins => 'competition_admins',
    'user_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Competition - DBIx::Class result source

=head1 DESCRIPTION

A tipping competition has zero or more tippers and zero or more administrators.
The administrators do not need to be tippers and vice versa.

=cut
