package Tipping::Schema::Result::Tip;
use parent 'DBIx::Class';

use Modern::Perl;

my $foreign_key = {
    data_type           => "integer",
    is_nullable         => 0,
};

__PACKAGE__->load_components(qw/ TimeStamp Core /);
__PACKAGE__->table('tbl_tip');
__PACKAGE__->add_columns(
    tipper_id        => $foreign_key,
    submitter_id     => $foreign_key,
    competition_id   => $foreign_key,
    game_id          => $foreign_key,

    home_team_to_win => {
        data_type   => 'boolean',
        is_nullable => 0,
    },
    timestamp        => {
        data_type       => 'datetime',
        set_on_create   => 1,
    },
);

__PACKAGE__->set_primary_key(qw/ tipper_id competition_id game_id timestamp /);

__PACKAGE__->belongs_to(
    tipper => 'Tipping::Schema::Result::User',
    'tipper_id'
);
__PACKAGE__->belongs_to(
    submitter => 'Tipping::Schema::Result::User',
    'submitter_id'
);
__PACKAGE__->belongs_to(
    game => 'Tipping::Schema::Result::Game',
    'game_id'
);
__PACKAGE__->belongs_to(
    competition => 'Tipping::Schema::Result::Competition',
    'competition_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game - DBIx::Class result source

=head1 DESCRIPTION

A tipper may make a tip for a game in the competition they are a tipper in.

=head1 BUGS AND LIMITATIONS

Tips can be entered by a tipper, or by an administrator of that competition.
We probably want an audit trail of who changed tips and when. In this regard
this table should probably be extended to:

    tipper, game, competition, timestamp, submitter

The primary key would also take the timestamp into account. The tip which
counts is the one with the latest timestamp.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
