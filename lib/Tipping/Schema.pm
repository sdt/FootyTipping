package Tipping::Schema;
use base qw/DBIx::Class::Schema/;

use version 0.77; our $VERSION = qv("v0.0.1");

use Modern::Perl;

# load all Result classes in Tipping/Schema/Result
__PACKAGE__->load_namespaces();

1;

__END__

=pod

=head1 NAME

Tipping::Schema - DBIX::Class::Schema class for Tipping

=head1 AUTHOR

Stephen Thirlwall <stephen.thirlwall@strategicdata.com.au>

=cut
