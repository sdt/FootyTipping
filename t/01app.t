#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Tipping::WebApp';

ok( request('/')->is_success, 'Request should succeed' );

done_testing();
