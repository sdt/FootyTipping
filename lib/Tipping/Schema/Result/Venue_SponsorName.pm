package Tipping::Schema::Result::Venue_SponsorName;
use parent 'DBIx::Class';

use Modern::Perl::5_14;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tbl_venue_sponsorname');
__PACKAGE__->add_columns(
    venue_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },
    name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    start_year => {
        data_type           => 'integer',
        is_nullable         => 1,
    },
    end_year => {
        data_type           => 'integer',
        is_nullable         => 1,
    },
);

__PACKAGE__->set_primary_key(qw/ venue_id name /);

__PACKAGE__->belongs_to(
    venue => 'Tipping::Schema::Result::Venue',
    'venue_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Venue_SponsorName - DBIx::Class result source

=head1 DESCRIPTION

A venue may sell naming rights to sponsors. A venue may have many sponsor names,
but only ever one at a time.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
