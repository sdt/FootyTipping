package Tipping::Config;

use Modern::Perl;
use Config::JFDI;
use Data::Dumper::Concise;

sub config {
    state $config = Config::JFDI->new(name => "Tipping");
    say STDERR "CONFIG: ", Dumper($config->get);
    return $config->get;
}

1;
