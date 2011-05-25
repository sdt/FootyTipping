package Tipping::Schema::ResultSet;
use parent 'DBIx::Class::ResultSet';

use Modern::Perl::5_14;

sub columns {
    my ($self, @columns) = @_;
    return $self->with_attr({ columns => \@columns });
}

sub rows {
    my ($self, $rows) = @_;
    return $self->with_attr({ rows => $rows });
}

sub order_by {
    my ($self, $order_by) = @_;
    return $self->with_attr({ order_by => $order_by });
}

sub with_attr {
    my ($self, $attr) = @_;
    return $self->search(undef, $attr);
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema::ResultSet.pm - DBIx::Class resultSet base class

=head1 DESCRIPTION

Base class for Tipping::Schema ResultSet classes. Adds some extra convenience
methods.

=head1 METHODS

=head2 columns (@columns)

Specify the columns to retrieve.

=head2 rows ($round)

Specify the number of rows to retrieve.

=head2 order_by ($attr)

Set a sort order on the query.

=head2 with_attr ($attr)

Catch-all which is the same as search(undef, $attr).

=head1 BUGS & LIMITATIONS

I like to push all my DBIC query logic into my ResultSet classes, and build
up queries using more domain-specific sub-queries.

  eg. $schema->resultset('Game')->round(5)->...

These let me tack on search attributes without uglying my code up with
      search(undef, $attr) type of things

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
