#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

use Catalyst::Test 'Tipping::WebApp';

ok( request('/')->is_redirect,      'Root request should redirect' );
ok( request('/login')->is_success,  'Login request should succeed' );

done_testing();
