package Tipping::Populator;

use Modern::Perl::5_14;

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

        # And an optional third one, related rows to update
        if (my $related = $row->{update_related}) {
            my $relation = $related->{relation};
            $db_row->$relation->set_columns($related->{values});
            $db_row->$relation->update;
        }
    }

    for my $row (@{ $data->{create_and_add_many} }) {
        my $db_row = $resultset->create($row->{create});
        my $add_related = 'add_to_' . $row->{add_many}->{relation};
        for my $related (@{ $row->{add_many}->{values} }) {
            $db_row->$add_related($related->{search}, $related->{extra});
        }
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
