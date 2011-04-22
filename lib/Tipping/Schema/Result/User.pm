package Tipping::Schema::Result::User;
use parent 'DBIx::Class';

use Modern::Perl;

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
    competition_users => 'Tipping::Schema::Result::Competition_User',
    'user_id'
);
__PACKAGE__->many_to_many(
    competitions => 'competition_users',
    'competition'   # GOTCHA!: competition, not competition_id!
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

A user has a username, password, email address and a real name.
A user has a screen name, but this is per competition.

A user can be a member of zero or more competitions.

A user has a set of capabilites per competition. By default a user has no
special capabilities.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
