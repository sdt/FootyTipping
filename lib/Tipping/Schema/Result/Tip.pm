package Tipping::Schema::Result::Tip;
use parent 'DBIx::Class';

use Modern::Perl;

my $foreign_key = {
    data_type           => "integer",
    is_nullable         => 0,
};

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tip');
__PACKAGE__->add_columns(
    user_id          => $foreign_key,
    game_id          => $foreign_key,
    home_team_to_win => {
        data_type   => 'boolean',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ user_id game_id /);

__PACKAGE__->belongs_to(
    user => 'Tipping::Schema::Result::User',
    'user_id'
);
__PACKAGE__->belongs_to(
    game => 'Tipping::Schema::Result::Game',
    'game_id'
);

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Game - Schema table representing individual games

=cut
