package Test::Tipping::Database;
use Modern::Perl;

use Carp            qw/ croak /;

sub install {
    my ($driver, $config) = @_;

    given ($driver) {

        when ('Pg') {
            use Test::postgresql ();
            my $pg = $config->{test_database} = Test::postgresql->new()
                or croak $Test::postgresql::errstr;
            my $dsn = $config->{database}->{dsn} = $pg->dsn;

            # STFU please postgres...
            my $dbh = DBI->connect($dsn);
            $dbh->do(q(ALTER USER postgres SET Client_min_messages='warning'))
                or croak $dbh->errstr;
        }

        when ('mysql') {
            use Test::mysqld ();
            $ENV{PATH} .= ':/usr/sbin';
            my $sqlite = $config->{test_database} = Test::mysqld->new(
                        my_cnf => { 'skip-networking' => '' }
                    ) or croak $Test::mysqld::errstr;
            $config->{database}->{dsn} = $sqlite->dsn;
        }

        when ('SQLite') {
            # The sqlite memory database is problematic. Connecting to the
            # same dsn twice creates two databases.
            # Instead, create one and store the handle, and use that as
            # the connect info.
            my $dbh = DBI->connect('dbi:SQLite:dbname=:memory:', undef, undef,
                    { RaiseError => 1, PrintError => 0, AutoCommit => 1 }
                );
            delete $config->{database}->{dsn};
            $config->{database}->{dbh_maker} = sub { $dbh };
        }

        default {
            die 'Expecting one of mysql, Pg, or SQLite';
        }
    }

    delete $config->{database}->{user};
    delete $config->{database}->{password};
}

1;

__END__

=pod

=head1 NAME

Test::Tipping::Database - Create temporary databases for tests

=head1 DESCRIPTION

Creates temporary database instances for use during testing. Currently
supports PostgreSQL, MySQL and SQLite.

PostgreSQL uses Test::postgresqld and MySQL uses Test::mysqld. SQLite uses
the built-in :memory: database.

The database is created and the database config attributes are written into
the supplied config hash.

=head1 SYNOPSIS

  use Tipping::Config;
  use Test::Tipping::Database;

  my $db_driver = 'Pg';
  Test::Tipping::Database::install($db_driver, Tipping::Config->config);

=head1 FUNCTIONS

=head2 install ($driver_name, $config_hash)

Creates a temporary database for the given database type, and modifies
$config_hash->{database}->{qw/ dsn user password } to use that database.

The temporary database object is written to $config_hash->{test_database} in
order to keep the database in scope. The database closes when the config hash
goes out of scope.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>


=cut
