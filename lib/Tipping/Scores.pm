package Tipping::Scores;

use Modern::Perl::5_14;
use Moose;
use Tipping::Schema;
use List::Util      qw/ min max /;
use namespace::autoclean;

has schema => (
    is      => 'ro',
    isa     => 'Tipping::Schema',
);

sub raw_scores_for_round {
    my ($self, $args) = @_;

    my @members = $self->schema->resultset('Membership')
                       ->search({ competition_id => $args->{competition_id} })
                       ->columns('membership_id')
                       ->get_column('membership_id')
                       ->all;

    # For each member we keep track of the number of correct tips, and
    # the number of games tipped.
    my %correct_tips = map { $_ => 0 } @members;
    my %games_tipped = map { $_ => 0 } @members;

    # Get the result for each game (as home score - away score)
    my %game_result;
    my $game_rs = $self->schema->resultset('Game')
                       ->round($args->{round})
                       ->with_teams;
    while (my $game = $game_rs->next) {
        die 'Round has not finished' if not $game->has_ended;
        $game_result{$game->game_id} = $game->home->score - $game->away->score;
    }

    # Go through the tips from newest to oldest, ignoring any duplicates.
    my $tips_rs = $self->schema->resultset('Tip')
                       ->round($args->{round})
                       ->competition($args->{competition_id})
                       ->newest_first;

    my %tip_seen;
    while (my $tip = $tips_rs->next) {
        next if exists $tip_seen{$tip->membership_id}->{$tip->game_id};
        $tip_seen{$tip->membership_id}->{$tip->game_id} =
            $tip->home_team_to_win;

        my $result = $game_result{$tip->game_id};
        if ($tip->home_team_to_win) {
            $correct_tips{$tip->membership_id} += ($result >= 0);
        }
        else {
            $correct_tips{$tip->membership_id} += ($result <= 0);
        }
        $games_tipped{$tip->membership_id}++;
    }

    # Split the score hash into two depending on whether all games tipped.
    my $game_count = scalar keys %game_result;
    my (%some, %all);
    while (my ($m_id, $score) = each %correct_tips) {
        my $hash = ($games_tipped{$m_id} == $game_count) ? \%all : \%some;
        $hash->{$m_id} = $score;
    }

    return (\%all, \%some);
}

sub scores_for_round {
    my ($self, $args) = @_;

    my ($all, $some) = $self->raw_scores_for_round($args);

    my $min_score  = min values %{ $all };
    my $awarded_score = max($min_score - 1, 0);

    # For all the some-tippers, add their awarded score to the all-tippers
    for my $id (keys %{ $some }) {
        $all->{$id} = max($some->{$id}, $awarded_score);
    }

    return $all;
}

__PACKAGE__->meta->make_immutable();
1;

__END__

=pod

=head1 NAME

Tipping::Scores - Computing scores for rounds

=head1 METHODS

=head2 new(schema => $schema)

Constructor.

=head2 raw_scores_for_round( { round => $, competition_id => $ } )

Computes raw scores for round, without any concessions for non-tippers.
Returns two hashes of the form { membership_id => score }
First is tippers who entered tips for all games, second is for tippers who
missed some games. Not tipping a game gives a score of zero for that game,
even if the game was a draw.

=head2 scores_for_round( { round => $, competition_id => $ } )

Computes final scores for a round. The score awarded to non tippers is one less
than the minimum score of the all-tippers. Partial tippers get the larger of
the non-tipper score and their own.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
