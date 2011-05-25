package Tipping::Schema::ResultSet::Tip;
use parent 'Tipping::Schema::ResultSet';

use Modern::Perl::5_14;

sub round {
    my ($self, $round) = @_;
    return $self->search(
            { 'game.round' => $round },
            { join => [qw/ game /] },
        );
}

sub tipper {
    my ($self, $user_id) = @_;
    return $self->search(
            { 'membership.user_id' => $user_id },
            { join => [qw/ membership /] },
        );
}

sub competition {
    my ($self, $comp_id) = @_;
    return $self->search(
            { 'membership.competition_id' => $comp_id },
            { join => [qw/ membership /] },
        );
}

sub oldest_first {
    my ($self) = @_;
    return $self->order_by({ -asc => 'timestamp' });
}

sub newest_first {
    my ($self) = @_;
    return $self->order_by({ -desc => 'timestamp' });
}

1;

=pod

=head1 NAME

Tipping::Schema::ResultSet::Tip - DBIx::Class ResultSet class

=head1 DESCRIPTION

Pre-defined tip searches.

=head1 METHODS

=head2 round ($round)

Filter the tips table by round.

=head2 tipper ($round)

Filter the tips table by tipper.

=head2 competition ($round)

Filter the tips table by competition.

=head2 oldest_first

Order the search by timestamp (oldest->newest)

=head2 newest_first

Order the search by timestamp (newest->oldest)

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
