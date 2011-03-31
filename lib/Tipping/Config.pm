package Tipping::Config;
use Modern::Perl;

use Config::JFDI;
use Data::Dumper::Concise;

sub config {
    state $config = Config::JFDI->new(name => "Tipping");
    die "Cannot find config file" unless $config->found;
    say STDERR "Tipping::Config = ", Dumper($config->get)
        if $config->{debug_config};
    return $config->get;
}

1;

=pod

=head1 NAME

Tipping::Config - Application configuration support using Config::JFDI

=head1 SYNOPSIS

use TIpping::Config;

$something = Tipping::Config->{something};

=head1 DESCRIPTION

By default will search for a file named tipping.$ext

Local overrides can be placed in tipping_local.$ext

The environment variable TIPPING_CONFIG can be used to override both.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
