package Tipping::Schema::Result::Membership;
use parent 'DBIx::Class';

use Modern::Perl::5_14;

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
__PACKAGE__->table('tbl_membership');
__PACKAGE__->add_columns(

    membership_id => {
        data_type               => 'integer',
        is_auto_increment       => 1,
        is_nullable             => 0,
    },

    user_id                     => $foreign_key,
    competition_id              => $foreign_key,

    can_submit_tips_for_others  => $user_capability,
    can_change_closed_tips      => $user_capability,
    can_grant_powers            => $user_capability,

    screen_name => {
        data_type           => 'varchar',
        is_nullable         => 1,
    },
);

__PACKAGE__->set_primary_key(qw/ membership_id /);
__PACKAGE__->add_unique_constraint([qw/ user_id competition_id /]);
__PACKAGE__->add_unique_constraint([qw/ competition_id screen_name /]);

__PACKAGE__->belongs_to(
    member => 'Tipping::Schema::Result::User',
    'user_id'
);
__PACKAGE__->belongs_to(
    competition => 'Tipping::Schema::Result::Competition',
    'competition_id'
);
__PACKAGE__->has_many(
    tips => 'Tipping::Schema::Result::Tip',
    'membership_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Membership - DBIx::Class result source

=head1 DESCRIPTION

A user can be a member of zero or more competitions. A competition has zero
or more members.

A membership in a competition includes capabilities for the user in that
competition. A user has an optional screen name for use in that competition.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
