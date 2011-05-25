package Tipping::Schema::Result::Tip;
use parent 'Tipping::Schema::Result';

use Modern::Perl::5_14;

my $foreign_key = {
    data_type           => "integer",
    is_nullable         => 0,
};

__PACKAGE__->load_components(qw/ TimeStamp Core /);
__PACKAGE__->table('tbl_tip');
__PACKAGE__->add_columns(
    membership_id    => $foreign_key,
    submitter_id     => $foreign_key,
    game_id          => $foreign_key,

    home_team_to_win => {
        data_type   => 'boolean',
        is_nullable => 0,
    },
    timestamp        => {
        data_type       => 'datetime',
        timezone        => 'UTC',
        set_on_create   => 1,
    },
);

__PACKAGE__->set_primary_key(qw/ membership_id game_id timestamp /);

__PACKAGE__->belongs_to(
    membership => 'Tipping::Schema::Result::Membership',
    'membership_id'
);
__PACKAGE__->belongs_to(
    game => 'Tipping::Schema::Result::Game',
    'game_id'
);
__PACKAGE__->belongs_to(
    submitter => 'Tipping::Schema::Result::User',
    'submitter_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game - DBIx::Class result source

=head1 DESCRIPTION

A tipper may make a tip for a game in the competition they are a tipper in.
Another user may submit this tip as well, provided they have the appropriate
permissions. This is noted in the submitter_id column.

When a tipper changes their tip a whole new row is created with a new timestamp.
Only the most recent tips are counted, but this leaves an audit trail of who
changed what tips.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
