package Tipping::Config;
use Modern::Perl;

use Carp (qw/ croak /);
use Config::JFDI ();
use Data::Dumper::Concise (qw/ Dumper /);

sub _build_config {
    my $config_obj = Config::JFDI->new(name => "Tipping");
    croak "Cannot find config file" if not $config_obj->found;
    my $config_hash = $config_obj->get;
    say STDERR "Tipping::Config = ", Dumper($config_hash)
        if $config_hash->{debug_config};
    return $config_hash;
}

sub config {
    state $config = _build_config;
    return $config;
}

1;

=pod

=head1 NAME

Tipping::Config - Application configuration support using Config::JFDI

=head1 SYNOPSIS

use Tipping::Config ();

$something = Tipping::Config->config->{something};

=head1 DESCRIPTION

By default will search for a file named tipping.$ext

Local overrides can be placed in tipping_local.$ext

The environment variable TIPPING_CONFIG can be used to override both.

=head1 FUNCTIONS

=head2 config

Returns a hash containing the current configuration. Loaded on demand.
Dies if config file cannot be found.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
