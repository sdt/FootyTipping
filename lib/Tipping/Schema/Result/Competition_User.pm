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

A user can be a member of zero or more competitions. A competition has zero
or more users.

There is only one type of user, but they have differing capabilities. A users
capabilities can vary between competitions.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
