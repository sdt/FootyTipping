package Tipping::Schema::Result::Team_Supporter;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('team_supporter');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
    team_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ user_id team_id /);

# no more than one team per user
__PACKAGE__->add_unique_constraint([ qw/ user_id / ]);

__PACKAGE__->belongs_to(
    supporter => 'Tipping::Schema::Result::User',
    'user_id'
);
__PACKAGE__->belongs_to(
    team => 'Tipping::Schema::Result::Team',
    'team_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Yeam_User - DBIx::Class result source

=head1 DESCRIPTION

A user may be a supporter of one team. A team has zero or more supporters.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
