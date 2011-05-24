#!/usr/bin/env perl

## Run Perl::Critic against the source code and the tests
## Requires TEST_CRITIC to be set

use Modern::Perl::5_14;
use Test::More;

eval "use Test::Perl::Critic (-severity => 2);";
if ($@) {
    plan skip_all => 'Test::Perl::Critic required for this test.';
}

unless ($ENV{TEST_CRITIC}) {
    plan skip_all => 'Set the environment variable TEST_CRITIC to enable this test';
}

all_critic_ok();
