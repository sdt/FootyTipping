#!/bin/sh
# Automated testing

# Bail out as soon as something fails
set -e

# Do the basic tests first
for db in mysql Pg SQLite; do
    echo Testing with $db
    TIPPING_DB_DRIVER=$db prove -wl t
done

# Then do another run with TEST_POD and TEST_CRITIC
TIPPING_DB_DRIVER=SQLite TEST_POD=1 TEST_CRITIC=1 prove -wl t

# Finally, do a Devel::Cover run
perl Makefile.PL
cover -delete
HARNESS_PERL_SWITCHES=-MDevel::Cover=+ignore,^$HOME/perl5,^t/ make test
cover
make distclean
