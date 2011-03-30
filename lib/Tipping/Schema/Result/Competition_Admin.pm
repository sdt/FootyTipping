package Tipping::Schema::Result::Competition_Admin;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('competition_admin');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
    competition_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ user_id competition_id /);

__PACKAGE__->belongs_to(
    user => 'Tipping::Schema::Result::User',
    'user_id'
);
__PACKAGE__->belongs_to(
    competition => 'Tipping::Schema::Result::Competition',
    'competition_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Competition_Admin - DBIx::Class result source

=head1 DESCRIPTION

Each competition has zero or more users who are administrators.
Administrators do not need to be a member of the competition, but usually are.
A user may be the administrator of multiple competitions.

=cut
