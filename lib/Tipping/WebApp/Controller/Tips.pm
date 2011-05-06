package Tipping::WebApp::Controller::Tips;
use Modern::Perl;
use Moose;
use Try::Tiny;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

sub tips :Chained('/login/required') :PathPath('tips') :CaptureArgs(1) {
    my ($self, $c, $comp_id) = @_;

    $c->stash->{round} = $c->request->params->{round} //
                         $c->model('DB::Game')->current_round;
    $c->stash->{user} = $c->request->params->{user}
                      ? $c->model('DB::User')->find(
                            { user_id => $c->request->params->{user} })
                      : $c->user->get_object;
    $c->stash->{comp} = $c->model('DB::Competition')->find(
                            { competition_id => $comp_id });

    return;
}

sub games :Private {
    my ($self, $c) = @_;

    my $game_rs = $c->model('DB::Game')->games->round($c->stash->{round});
    my @games;
    while (my $game = $game_rs->next) {
        push(@games, {
                tips        => $game->tips->search_rs,
                home_team   => $game->home->team->name,
                away_team   => $game->away->team->name,
                venue       => $game->venue->name,
                time        => $game->start_time_utc->clone->set_time_zone('Australia/Melbourne')->strftime('%A %B %d %I:%M%P %Z'),
            });
    }

    if (not @games) {
        $c->detach('/default');
    }
    $c->stash(games => \@games);

    return;
}

sub view :Chained('tips') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    $c->forward('games');

    $c->stash(rounds => [ $c->model('DB::Game')->rounds ]);

    my $user_id = $c->stash->{user}->id;
    my $comp_id = $c->stash->{comp}->id;

    for my $game (@{ $c->stash->{games} }) {
        my $tip = $game->{tips}->search(
            {
                tipper_id      => $user_id,
                competition_id => $comp_id,
            },
            {
                order_by  => { '-desc' => 'timestamp' },
                rows      => 1,
            }
        )->first;
        $game->{tip} = $tip;
        delete $game->{tips};
    }

    return;
}

=pod

sub vXiew :Chained('games') :PathPath('view') :Args(2) {
    my ($self, $c, $comp_id, $user_id) = @_;

    try {
        my $user = ($c->user->id == $user_id) ? $c->user->get_object
                 : $c->model('DB::User')->find( { user_id => $user_id });
        my $competition = $user->competitions->find({ competition_id => $comp_id });

        if (!$c->user->can_view_tips({
                other_user  => $user,
                competition => $competition,
                round       => $c->stash->{round},
            })) {
            die 'User does not have permission to view tips';
        }

        for my $game (@{ $c->stash->{games} }) {
            my $tip = $game->{tips}->search(
                {
                    tipper_id      => $user_id,
                    competition_id => $comp_id,
                },
                {
                    order_by  => { '-desc' => 'timestamp' },
                    rows      => 1,
                }
            )->first;
            $game->{tip} = $tip;
            delete $game->{tips};
        }
    }
    catch {
        say STDERR $_;
        $c->detach('/default');
    };

    return;
}
=cut

__PACKAGE__->meta->make_immutable;
1;

__END__
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
