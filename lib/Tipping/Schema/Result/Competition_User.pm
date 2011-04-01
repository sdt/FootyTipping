package Tipping::Schema::Result::Competition_User;
use parent 'DBIx::Class';

use Modern::Perl;

my $foreign_key = {
    data_type           => 'integer',
    is_nullable         => 0,
};

my $user_capability = {
    data_type           => 'boolean',
    is_nullable         => 0,
    default_value       => 0,
};

__PACKAGE__->load_components('Core');
__PACKAGE__->table('competition_user');
__PACKAGE__->add_columns(
    user_id                     => $foreign_key,
    competition_id              => $foreign_key,

    can_submit_tips_for_others  => $user_capability,
    can_change_closed_tips      => $user_capability,
    can_grant_powers            => $user_capability,
);

__PACKAGE__->set_primary_key(qw/ user_id competition_id /);

__PACKAGE__->belongs_to(
    user => 'Tipping::Schema::Result::User',
    'user_id'
);
__PACKAGE__->belongs_to(
    competition => 'Tipping::Schema::Result::Competition',
    'competition_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Competition_User - DBIx::Class result source

=head1 DESCRIPTION

A tipper is a user connected to a competition.

A competition has zero or more users. A user may be a tipper in zero or more
competitions.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
