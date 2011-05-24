#!/usr/bin/env perl
use Modern::Perl::5_14;
use Plack::Builder;
use Tipping::WebApp;

Tipping::WebApp->setup_engine('PSGI');
my $app = sub { Tipping::WebApp->run(@_) };

builder {
    enable_if { $ENV{PLACK_ENV} eq 'development' } 'Debug', panels => [
            qw/ Environment Memory Response Timer /,
            [ 'DBIProfile', profile => 2 ]
        ];
    $app;
};
