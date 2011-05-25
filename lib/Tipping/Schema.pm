package Tipping::Schema;
use Modern::Perl::5_14;

use base qw/DBIx::Class::Schema/;
our $VERSION = "1";

use Tipping::Config ();

# load all Result classes in Tipping/Schema/Result
__PACKAGE__->load_namespaces( default_resultset_class => 'ResultSet' );

sub connect {                           ## no critic (ProhibitBuiltinHomonyms)
    my ($class, @params) = @_;
    if (@params) {
        return $class->next::method(@params);
    }
    return $class->next::method(Tipping::Config->config->{database});
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema - DBIX::Class::Schema class for Tipping

=head1 METHODS

=head2 connect

Overload of DBIx::Class::Schema::connect which defaults to using the
connect info in Tipping::Config.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
