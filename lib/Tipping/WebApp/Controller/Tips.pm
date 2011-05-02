package Tipping::WebApp::Controller::Tips;
use Modern::Perl;
use Moose;
use Try::Tiny;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

sub tips :Chained('/login/required') :PathPath('tips') :CaptureArgs(2) {
    my ($self, $c, $season, $round) = @_;

    $c->stash(season => $season);
    $c->stash(round  => $round);

    return;
}

sub games :Chained('tips') :PathPart('') :CaptureArgs(0) {
    my ($self, $c) = @_;

    my $game_rs = $c->model('DB::Game')->games->search(
        {
            'season' => $c->stash->{season},
            'round'  => $c->stash->{round},
        });
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

sub view :Chained('games') :PathPath('view') :Args(2) {
    my ($self, $c, $comp_id, $user_id) = @_;

    # User A can view user B's competition C tips if:
    # - user A is superuser, or
    # - user A is also in competition C, and
    #   - that round has finished, or
    #   - user A has can_submit_tips_for_others in competition C
    try {
        my $user = ($c->user->id == $user_id) ? $c->user
                 : $c->model('DB::User')->find( { user_id => $user_id });
        die "Unknown user id $user_id" if not $user;

        my $competition = $user->competitions->find({ competition_id => $comp_id });
        die 'User ' . $user->username . " is not a member of comp $comp_id"
            if not $competition;

        if ($user_id != $c->user->id) {
            if (!$c->user->can_view_tips({
                    other_user  => $user,
                    competition => $competition,
                    season      => $c->stash->{season},
                    round       => $c->stash->{round},
                })) {
                die 'User does not have permission to view tips';
            }
        }
    }
    catch {
        say STDERR $_;
        $c->detach('/default');
    };

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
