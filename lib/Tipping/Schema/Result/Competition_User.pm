package Tipping::Schema::Result::Competition_User;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('competition_user');
__PACKAGE__->add_columns(
    user_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
    competition_id => {
        data_type           => 'integer',
        is_nullable         => 0,
    },
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

Tipping::Schema::Result::Competition_User - Schema table representing many-to-many relationship between users and tipping competitions

=cut
