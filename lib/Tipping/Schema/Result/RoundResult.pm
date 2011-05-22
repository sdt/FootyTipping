package Tipping::Schema::Result::RoundResult;
use parent 'DBIx::Class';

use Modern::Perl::5_14;

my $foreign_key = {
    data_type           => "integer",
    is_nullable         => 0,
};

__PACKAGE__->load_components(qw/ Core /);
__PACKAGE__->table('tbl_round_result');
__PACKAGE__->add_columns(

    membership_id => {
        data_type       => "integer",
        is_nullable     => 0,
    },

    round => {
        data_type       => "integer",
        is_nullable     => 0,
    },

    score => {
        data_type       => "integer",
        is_nullable     => 0,
    },

);

__PACKAGE__->set_primary_key(qw/ membership_id round /);

__PACKAGE__->belongs_to(
    membership => 'Tipping::Schema::Result::Membership',
    'membership_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::RoundResult - DBIx::Class result source

=head1 DESCRIPTION

At the end of each round, the scores for each competition are computed and
stored in the round result table.

Note that this table is a summary table - the data can be computed from other
tables.

If we went the oztips way and assigned away teams to non-tippers, this table
would probably not be necessary. Because we base the non-tipper scores on the
all-tipper scores, we need to compute all the scores for a round at once.
Computing a tipping ladder would in turn require computing all rounds for
the season.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
