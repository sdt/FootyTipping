package Tipping::Config;
use Modern::Perl;

use Carp (qw/ croak /);
use Config::ZOMG ();
use Data::Dumper::Concise (qw/ Dumper /);

sub _build_config {
    my $config = Config::ZOMG->open(name => "Tipping")
        or croak "Cannot find config file";
    say STDERR "Tipping::Config = ", Dumper($config)
        if $config->{debug_config};
    return $config;
}

sub config {
    state $config = _build_config;
    return $config;
}

1;

=pod

=head1 NAME

Tipping::Config - Application configuration support using Config::ZOMG

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
