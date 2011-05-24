package Tipping::Schema::Result::RoundResultTimestamp;
use parent 'DBIx::Class';

use Modern::Perl::5_14;

my $foreign_key = {
    data_type           => "integer",
    is_nullable         => 0,
};

__PACKAGE__->load_components(qw/ InflateColumn::DateTime Core /);
__PACKAGE__->table('tbl_round_result_timestamp');
__PACKAGE__->add_columns(
    competition_id => {
        data_type       => "integer",
        is_nullable     => 0,
    },
    round => {
        data_type       => "integer",
        is_nullable     => 0,
    },
    timestamp => {
        data_type       => 'datetime',
        timezone        => 'UTC',
        is_nullable     => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ competition_id round /);

__PACKAGE__->belongs_to(
    competition => 'Tipping::Schema::Result::Competition',
    'competition_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::RoundResult - DBIx::Class result source

=head1 DESCRIPTION

This table allows us to check that the round results for a competition are up
to date.

The results are up to date if a result timestamp exists, and the is newer than
all of the tipping timestamps.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
