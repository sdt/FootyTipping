package Modern::Perl::5_14;

our $VERSION = '1.01';

use 5.014_000;

use strict;
use warnings;

use mro      ();
use feature  ();
use indirect ();

sub import {
    warnings->import();
    strict->import();
    feature->import( ':5.14' );
    mro::set_mro( scalar caller(), 'c3' );
    indirect->unimport();
    return;
}

1;
__END__

=pod

=head1 NAME

Modern::Perl::5_14 - Modern::Perl for 5.14

=head1 VERSION

Version 1.01

=head1 DESCRIPTION

Modern::Perl for 5.14. Straight copy from chromatic's version with the tens
changed to fourteens.

Update: added 'no indirect'

=head1 SYNOPSIS

use Modern::Perl::5_14;

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=head1 ACKNOWLEDGEMENTS

chromatic C<< <chromatic at wgz.org> >> wrote Modern::Perl.
I just changed some zeros to fours.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.14 itself.

=cut
