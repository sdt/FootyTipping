package Tipping::Schema::Result::User;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_auto_increment   => 1,
        is_nullable         => 0,
    },
    user_name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    real_name => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
    screen_name => {
        data_type           => 'varchar',
        is_nullable         => 1,
    },
    password => {
        data_type           => 'varchar',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key('user_id');

__PACKAGE__->add_unique_constraint([ qw/ user_name / ]);
__PACKAGE__->add_unique_constraint([ qw/ real_name / ]);
__PACKAGE__->add_unique_constraint([ qw/ screen_name / ]);

__PACKAGE__->has_many(
    tips => 'Tipping::Schema::Result::Tip',
    'tipper_id'
);

__PACKAGE__->has_many(
    competition_tippers => 'Tipping::Schema::Result::Competition_Tipper',
    'user_id'
);
__PACKAGE__->many_to_many(
    competitions => 'competition_tippers',
    'competition_id'
);

__PACKAGE__->has_many(
    competition_admins => 'Tipping::Schema::Result::Competition_Admin',
    'user_id'
);
__PACKAGE__->many_to_many(
    competitions_administered => 'competition_admins',
    'competition_id'
);

__PACKAGE__->might_have(
    team => 'Tipping::Schema::Result::Team_Supporter',
    'user_id'
);


1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::User - DBix:Class result source

=head1 DESCRIPTION

A user can be a tipper in zero or more competitions or an administrator of zero
or more competitions.

A user who is a tipper in a competition may enter tips for themselves in that
competition, until tipping closes for a particular game.

A user who is an administrator of a competition may enter tips for any users in
that competition, at any time.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
