package Tipping::Schema::ResultSet::RoundResult;
use parent 'DBIx::Class::ResultSet';

use Modern::Perl::5_14;
use Tipping::Scores;

sub update_results {
    my ($self, $args) = @_;

    my $round          = $args->{round};
    my $competition_id = $args->{competition_id};

    my $schema = $self->result_source->schema;

    $schema->txn_do(sub{

        my $tip_timestamp = $schema->resultset('Tip')
                                   ->round($round)
                                   ->competition($competition_id)
                                   ->newest_first
                                   ->search(undef, {
                                        rows => 1,
                                        columns  => [qw/ me.timestamp /],
                                     })
                                   ->single
                                   ->get_inflated_column('timestamp');

        my $result_timestamp = $schema->resultset('RoundResultTimestamp')
                                      ->find({
                                            round          => $round,
                                            competition_id => $competition_id,
                                        });

        if ((not defined $result_timestamp) or
            ($result_timestamp->timestamp < $tip_timestamp)) {

            my $scores = Tipping::Scores->new( schema => $schema );
            my $round_scores = $scores->scores_for_round($args);

            while (my ($membership_id, $score) = each %{ $round_scores }) {
                $self->update_or_create(
                        {
                            membership_id => $membership_id,
                            round         => $round,
                            score         => $score,
                        });
            }

            # Set the round result timestamp to be the same as the most recent
            # tip.
            $schema->resultset('RoundResultTimestamp')
                   ->update_or_create({
                        round           => $round,
                        competition_id  => $competition_id,
                        timestamp       => $tip_timestamp,
                });
        }
    });

    return;
}

1;

=pod

=head1 NAME

Tipping::Schema::ResultSet::RoundResult - DBIx::Class ResultSet class

=head1 DESCRIPTION

Pre-defined game searches.

=head1 METHODS

=head2 update_results (round => $, competition_id => $)

Update the round results for a given round and competition.

Only updates the results if they are out of date.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
