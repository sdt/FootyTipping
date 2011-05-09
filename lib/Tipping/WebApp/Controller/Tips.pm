package Tipping::WebApp::Controller::Tips;
use Modern::Perl;
use Moose;
use Try::Tiny;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole'; }

sub tips :Chained('/login/required') :PathPath('tips') :CaptureArgs(0) {
    my ($self, $c) = @_;

    $c->stash->{round} = $c->request->params->{round} //
                         $c->model('DB::Game')->current_round;
    $c->stash->{user} = $c->request->params->{user}
                      ? $c->model('DB::User')->find(
                            { user_id => $c->request->params->{user} })
                      : $c->user->get_object;
    $c->stash->{comp_id} = $c->request->params->{comp_id} //
                           $c->stash->{user}->competition_users
                                            ->first->competition_id;

    return;
}

# Stash a list of the rounds for this season
sub rounds: Private {
    my ($self, $c) = @_;

    $c->stash(rounds => [ $c->model('DB::Game')->rounds ]);

    return;
}

# Stash a list of the games for this round
sub games :Private {
    my ($self, $c) = @_;

    my @games = $c->model('DB::Game')
                  ->round($c->stash->{round})
                  ->inflate_games
                  ->all;

    if (not @games) {
        $c->detach('/default');
    }
    $c->stash(games => \@games);

    return;
}

# Annotate the stashed games with tips for the stashed user
sub game_tips :Private {
    my ($self, $c) = @_;

    # Grab all the relevant tips, don't bother removing ones which
    # have been superceded - there won't be many of these anyway.
    my $tip_rs = $c->model('DB::Tip')
                   ->round($c->stash->{round})
                   ->user($c->stash->{user}->id)
                   ->competition($c->stash->{comp_id})
                   ->order_by_date;

    # Create a lookup hash for the games
    my %game = map { $_->game_id => $_ } @{ $c->stash->{games} };

    # The tips are ordered from oldest to newest. Just enter them as
    # we get them. Newer ones will overwrite older ones.
    while (my $tip = $tip_rs->next) {
        $game{$tip->game_id}->{tip} = $tip;
    }

    return;
}

sub view :Chained('tips') :PathPart('view') :Args(0) {
    my ($self, $c) = @_;

    if (not $c->user->can_view_tips(
            other_user  => $c->stash->{user},
            comp_id     => $c->stash->{comp_id},
            round       => $c->stash->{round},
         )) {
        $c->detach('/default');
    }

    $c->forward('rounds');
    $c->forward('games');
    $c->forward('game_tips');

    $c->stash->{start_time} = sub {
            my ($game) = @_;
            my $tz = 'Australia/Melbourne'; #TODO: get from user
            my $fmt = '%A %B %d %I:%M%P %Z';
            my $start_time = $game->start_time_utc->clone;
            return $start_time->set_time_zone($tz)->strftime($fmt);
        };

    $c->stash->{can_edit} = $c->user->can_edit_tips(
                other_user  => $c->stash->{user},
                comp_id     => $c->stash->{comp_id},
                round       => $c->stash->{round},
            );

    return;
}

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

=head2 rounds

=head2 games

=head2 game_tips

=head2 view

=head1 AUTHOR

Stephen Thirlwall,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
