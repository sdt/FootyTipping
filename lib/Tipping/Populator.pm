package Tipping::Populator;

use Modern::Perl;

use Data::Dumper::Concise (qw/ Dumper /);
use List::MoreUtils (qw/ zip /);
use Params::Validate (qw/ validate :types /);
use YAML::XS ();


sub populate {
    my %args = validate(@_, {
            schema => {
                isa => 'DBIx::Class::Schema',
            },
            yaml => {
                type => SCALAR,
            },
            verbose => {
                type => SCALAR,
                optional => 1,
            },
        });

    my ($data) = YAML::XS::Load($args{yaml});
    say STDERR Dumper($data) if $args{verbose};

    my $resultset = $args{schema}->resultset($data->{table});

    # Each item in a create set is just a hashref
    for my $row (@{ $data->{create} }) {
        $resultset->create($row);
    }

    # Update sets have two hashrefs, one to search on, and one to update with.
    for my $row (@{ $data->{update} }) {
        my $db_row = $resultset->find($row->{search}, $data->{attr});
        $db_row->set_columns($row->{update});
        $db_row->update;
    }

    return;
}

1;

__END__

=pod

=head1 NAME

Tipping::Populator - Helper class to populate database tables from yaml files

=head1 DESCRIPTION

Metadata tables such as team, venue, game need to be bulk created. This module
is intended to make this easy by defining a yaml format to create and update
metadata tables.

=head1 SUBROUTINES

=head2 populate(schema => $schema, yaml => $yamldata, [ $verbose => 1)

Populate the database with the given yaml data.

=head1 BUGS AND LIMITATIONS

Needs a better name.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
