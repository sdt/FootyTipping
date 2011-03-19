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
);

__PACKAGE__->set_primary_key('venue_id');

__PACKAGE__->has_many(
    games => 'Tipping::Schema::Result::Game',
    'venue_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Venue

=cut
