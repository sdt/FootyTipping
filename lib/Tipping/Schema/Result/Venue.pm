package Tipping::Schema::Result::Venue;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('venue');
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
    sponsor_name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    time_zone => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key('venue_id');

__PACKAGE__->add_unique_constraint([ qw/ name / ]);
__PACKAGE__->add_unique_constraint([ qw/ sponsor_name / ]);

__PACKAGE__->has_many(
    games => 'Tipping::Schema::Result::Game',
    'venue_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Venue - DBIx::Class result source

=head1 DESCRIPTION

Games take place at a venue. The venue has a real name, and a sponsor name.

=head1 BUGS AND LIMITATIONS

The sponsor name of a venue may change over time. The main name may as well.
Ideally, we should have a venue with maybe an address and a timezone, and then
two other tables for name and sponsor name which also include start and end
dates.

eg. Docklands stadium was called Colonial Stadium, Telstra Dome, Etihad Stadium

This means that historical games will be listed with the correct stadium name.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
