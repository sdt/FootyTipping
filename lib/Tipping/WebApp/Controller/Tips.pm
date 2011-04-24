package Tipping::WebApp::Controller::Tips;
use Modern::Perl;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

sub tips :Chained('/') :PathPath('tips') :CaptureArgs(2) {
    my ($self, $c, $season, $round) = @_;

    $c->stash(season => $season);
    $c->stash(round  => $round);

    return;
}

sub games :Chained('tips') :PathPart('') :CaptureArgs(0) {
    my ($self, $c) = @_;

    my $game_rs = $c->model('DB::Game')->search(
        {
            'season' => $c->stash->{season},
            'round'  => $c->stash->{round},
            'home.is_home_team' => 1,
            'away.is_home_team' => 0,
        },
        {
            prefetch => [qw/ venue /, { home => 'team' }, { away => 'team' }],
            join     => [qw/ venue home away /],
        },
    );
    my @games;
    while (my $game = $game_rs->next) {
        push(@games, {
                home_team => $game->home->team->name,
                away_team => $game->away->team->name,
                venue     => $game->venue->name,
            });
    }

    if (not @games) {
        $c->detach('/default');
    }
    $c->stash(games => \@games);

    my $rounds_rs = $c->model('DB::Game')->search(
        {
            season => $c->stash->{season},
        },
        {
            order_by => [qw/ round /],
            distinct => 1,
        },
    );
    $c->stash(rounds => [ $rounds_rs->get_column('round')->all ]);

    return;
}

sub view :Chained('games') :PathPath('view') :Args(2) :Does('NeedsLogin') {
    my ($self, $c, $comp_id, $user_id) = @_;

    return;
}

1;

=pod

=head1 NAME

Tipping::WebApp::Controller::Tips - Catalyst Controller

=head1 DESCRIPTION

Catalyst controller for viewing and editing tips.

=head1 METHODS

=head2 tips

=head2 games

=head2 view

=head1 AUTHOR

Stephen Thirlwall,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
