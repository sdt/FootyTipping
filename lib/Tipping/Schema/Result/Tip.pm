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
    tipper_id        => $foreign_key,
    competition_id   => $foreign_key,
    game_id          => $foreign_key,
    home_team_to_win => {
        data_type   => 'boolean',
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key(qw/ tipper_id competition_id game_id /);

__PACKAGE__->belongs_to(
    tipper => 'Tipping::Schema::Result::User',
    'tipper_id'
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

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
