package Tipping::Schema;
use Modern::Perl;

use base qw/DBIx::Class::Schema/;
our $VERSION = "1";

use Tipping::Config ();

# load all Result classes in Tipping/Schema/Result
__PACKAGE__->load_namespaces();

sub instance {
    state $instance = __PACKAGE__->connect(Tipping::Config->config->{database});
    return $instance;
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema - DBIX::Class::Schema class for Tipping

=head1 METHODS

=head2 instance

Returns a singleton instance of the schema created on-demand from
Tipping::Config.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
