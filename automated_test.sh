#!/bin/sh
# Automated testing

make distclean > /dev/null 2> /dev/null

# Bail out as soon as something fails
set -e

squeak() {
    local color=$1
    shift
    /bin/echo -e "\033[${color}m$@\033[0m"
}

# Do a run with SQLite and the extra test flags
db=SQLite
squeak 33 Testing with $db \(and TEST_POD and TEST_CRITIC\)
TIPPING_DB_DRIVER=$db TEST_POD=1 TEST_CRITIC=1 prove -wl t

# Do the basic tests first
for db in mysql Pg ; do
    squeak 33 Testing with $db
    TIPPING_DB_DRIVER=$db prove -wl t
done

# Finally, do a Devel::Cover run
squeak 33 Building coverage database
perl Makefile.PL > /dev/null
cover -delete -test 2> /dev/null
make distclean > /dev/null 2> /dev/null

squeak 32 All done
