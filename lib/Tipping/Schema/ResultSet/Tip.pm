package Tipping::Schema::ResultSet::Tip;
use parent 'DBIx::Class::ResultSet';

use Modern::Perl;

sub round {
    my ($self, $round) = @_;
    return $self->search(
            { 'game.round' => $round },
            { prefetch => [qw/ game /] },
        );
}

sub tipper {
    my ($self, $user_id) = @_;
    return $self->search({ tipper_id => $user_id });
}

sub competition {
    my ($self, $comp_id) = @_;
    return $self->search({ competition_id => $comp_id });
}

sub order_by_date {
    my ($self) = @_;
    return $self->search(undef, { order_by => 'timestamp' });
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

=head2 order_by_date

Order the search by timestamp (oldest->newest)

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
