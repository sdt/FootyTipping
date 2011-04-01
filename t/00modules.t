#!/usr/bin/env perl
use Modern::Perl;

=head1 DESCRIPTION

Make sure that every *.pm will load properly.

=cut

use Test::More qw(no_plan);
use File::Find;
# You may need a 'use lib' here..

find({ wanted => \&wanted, no_chdir => 1 }, qw/ lib /);

sub wanted {
    return unless -f $_;
    return if $File::Find::dir =~ m!/.svn($|/)!;
    return if $File::Find::name =~ /~$/;
    return unless $File::Find::name =~ /\.pm$/;

    (my $filename) = $File::Find::name =~ m{^$File::Find::topdir/(.*\.pm)$};

    require_ok( $filename );
}
