package Tipping::Schema::Result::Venue;
use parent 'Tipping::Schema::Result';

use Modern::Perl::5_14;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tbl_venue');
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
    time_zone => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key('venue_id');

__PACKAGE__->add_unique_constraint([ qw/ name / ]);

__PACKAGE__->has_many(
    games => 'Tipping::Schema::Result::Game',
    'venue_id'
);

__PACKAGE__->has_many(
    sponsor_names => 'Tipping::Schema::Result::Venue_SponsorName',
    'venue_id'
);

#TODO: is this the right place for this? Feels wrong doing a query here.
sub sponsor_name {
    my ($self, $year) = @_;

    my $sponsor = $self->sponsor_names->find({
            start_year => [
                { '<=' => $year },
                { '='  => undef },
            ],
            end_year => [
                { '>=' => $year },
                { '='  => undef },
            ]
        });

    if (defined $sponsor) {
        return $sponsor->name;
    }
    return;
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Venue - DBIx::Class result source

=head1 DESCRIPTION

Games take place at a venue. The venue has a real name, a time zone, and
many sponsor names (but only one in any given year).

=head1 METHODS

=head2 sponsor_name($year)

Returns the sponsor name for the given year, or undef if none exists;

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
