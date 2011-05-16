package Tipping::Schema::Result::User;
use parent 'DBIx::Class';

use Modern::Perl::5_14;
use List::MoreUtils (qw/ all any /);
use Params::Validate (qw/ validate :types /);

my $string = {
    data_type           => 'varchar',
    is_nullable         => 0,
};

__PACKAGE__->load_components(qw/ EncodedColumn Core /);
__PACKAGE__->table('tbl_user');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },

    username  => $string,
    real_name => $string,
    email     => $string,

    password => {
        data_type           => 'char',
        size                => 50,
        is_nullable         => 0,

        encode_column       => 1,
        encode_class        => 'Digest',
        encode_check_method => 'check_password',
        encode_args         => {
            algorithm   => 'SHA-1',
            format      => 'hex',
            salt_length => 10
        },
    },

    is_superuser => {
        data_type           => 'boolean',
        is_nullable         => 0,
        default_value       => 0,
    }
);

__PACKAGE__->set_primary_key('user_id');

__PACKAGE__->add_unique_constraint([ qw/ username  / ]);
__PACKAGE__->add_unique_constraint([ qw/ real_name / ]);

__PACKAGE__->has_many(
    tips => 'Tipping::Schema::Result::Tip',
    'tipper_id'
);
__PACKAGE__->has_many(
    submitted_tips => 'Tipping::Schema::Result::Tip',
    'submitter_id'
);

__PACKAGE__->has_many(
    memberships => 'Tipping::Schema::Result::Competition_User',
    'user_id'
);
__PACKAGE__->many_to_many(
    competitions => 'memberships',
    'competition'   # GOTCHA!: competition, not competition_id!
);

__PACKAGE__->might_have(
    team => 'Tipping::Schema::Result::Team_Supporter',
    'user_id'
);

sub can_view_tips {
    my $self = shift;
    my $ns = 'Tipping::Schema::';
    my %args = validate(@_, {
            tipper     => { isa => $ns . 'Result::User' },
            membership => { isa => $ns . 'Result::Competition_User' },
            games      => { type => ARRAYREF },
        });

    # We already know that:
    # - user is normal user (not superuser)
    # - user and tipper are both members of membership->competition

    # User A can view user B's competition C tips if:
    # - that round has completely finished, or
    # - user A has can_submit_tips_for_others in competition C

    if ($self->user_id == $args{tipper}->user_id) {
        return 1;   # can always view your own tips
    }

    if ($args{membership}->can_submit_tips_for_others) {
        return 1;   # can view/change tips for others
    }

    # can view tips for others in your own comp if all games have ended
    return all { $_->has_ended } @{ $args{games} };
}

sub can_edit_tips {
    my $self = shift;
    my $ns = 'Tipping::Schema::';
    my %args = validate(@_, {
            tipper     => { isa => $ns . 'Result::User' },
            membership => { isa => $ns . 'Result::Competition_User' },
            games      => { type => ARRAYREF },
        });

    # We already know that:
    # - user is normal user (not superuser)
    # - user and tipper are both members of membership->competition

    # User A can edit user B's competition C tips if:
    # - user A is user B, or A can_submit_tips_for_others, -and-
    # - games have not all started, or A can_change_closed_tips

    if (($self->user_id != $args{tipper}->id) and
        (not $args{membership}->can_submit_tips_for_others)) {
        return; # can't submit tips for other users
    }

    if ($args{membership}->can_change_closed_tips) {
        # Don't bother checking the games - this user can edit tips
        return 1;
    }

    # Tipper can edit tips if some of the games are yet to start
    my $now = DateTime->now( time_zone => 'UTC' );
    return not all { $_->has_started($now) } @{ $args{games} };
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::User - DBix:Class result source

=head1 DESCRIPTION

A user has a username, password, email address and a real name.
A user can be a member of zero or more competitions.

=head1 METHODS

=head2 can_view_tips

Determines whether the current user can view another users tips for a given
competition and round.

=head2 can_edit_tips

Determines whether the current user can view another users tips for a given
competition and round.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
