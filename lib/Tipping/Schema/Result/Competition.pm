package Tipping::Schema::Result::Competition;
use parent 'Tipping::Schema::Result';

use Modern::Perl::5_14;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tbl_competition');
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
    round_result_timestamps => 'Tipping::Schema::Result::RoundResultTimestamp',
    'competition_id'
);
__PACKAGE__->has_many(
    memberships => 'Tipping::Schema::Result::Membership',
    'competition_id'
);
__PACKAGE__->many_to_many(
    members => 'memberships',
    'member'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Competition - DBIx::Class result source

=head1 DESCRIPTION

A tipping competition has a name, many members, and an optional password that
users must provide in order to join.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
