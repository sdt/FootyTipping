package Tipping::DeploymentHandler;

use Modern::Perl;

use Carp (qw/ croak /);
use Data::Dumper::Concise (qw/ Dumper /);
use DBIx::Class::DeploymentHandler ();
use File::ShareDir (qw/ module_dir /);
use SQL::Translator ();
use Tipping::Schema ();
use Moose;

has schema => (
    is      => 'ro',
    isa     => 'DBIx::Class::Schema',
    default => sub { Tipping::Schema->connect },
);

has _deployment_handler => (
    is          => 'ro',
    isa         => 'DBIx::Class::DeploymentHandler',
    lazy_build  => 1,
);

sub _build__deployment_handler { ## no critic (ProhibitUnusedPrivateSubroutines)
    my $self = shift;

    my $dh = DBIx::Class::DeploymentHandler->new( {
        schema              => $self->schema,
        databases           => [qw/ SQLite PostgreSQL MySQL /],
        sql_translator_args => { add_drop_table => 0, },
        force_overwrite     => 1,
        #script_directory    => module_dir('Tipping::DeploymentHandler'),
    } );

    return $dh;
}

sub prepare {
    my $self = shift;

    $self->_deployment_handler->prepare_install;

    my $version = $self->schema->VERSION;

    if ($version > 1) {
        $self->_deployment_handler->prepare_upgrade({
                from_version => $version - 1,
                to_version   => $version,
                version_set  => [ $version - 1, $version ],
            });

        $self->_deployment_handler->prepare_downgrade({
                from_version => $version,
                to_version   => $version - 1,
                version_set  => [ $version, $version - 1 ],
            });
    }

    my $trans = SQL::Translator->new(
        parser        => 'SQL::Translator::Parser::DBIx::Class',
        parser_args   => { package => $self->schema },
        producer      => 'Diagram',
        producer_args => {
            out_file         => 'sql/diagram-v' . $version . '.png',
            show_constraints => 1,
            show_datatypes   => 1,
            show_sizes       => 1,
            show_fk_only     => 0,
        } );

    $trans->translate;

    return;
}

sub update {
    my $self = shift;

    my $schema_version = $self->_deployment_handler->schema_version;
    my $database_version = eval { $self->_deployment_handler->database_version };
    if (!defined $database_version) {
        say "Installing schema v$schema_version";
        $self->_deployment_handler->install;
    }
    elsif ($database_version < $schema_version) {
        say "Upgrading schema from v$database_version to v$schema_version";
        $self->_deployment_handler->upgrade;
    }
    elsif ($database_version > $schema_version) {
        croak "Downgrade schema from v$database_version to v$schema_version "
          . "not yet supported";
    }
    else {
        say "Schema already up to date at v$schema_version";
    }

    return;
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;

__END__

=pod

=head1 NAME

Tipping::DeploymentHandler - Schema deploy and upgrade handler

=head1 SYNOPSIS

# Prepare the schema update files
my $dh = Tipping::DeploymentHandler->new(schema => $schema);
$dh->prepare;

# Deploy or update the database
my $dh = Tipping::DeploymentHandler->new(schema => $schema);
$dh->update;

=head1 DESCRIPTION

Wrapper around DBIx::Class::DeploymentHandler to handle database versioning.

=head1 METHODS

=head2 new(schema => $schema)

Constructor.

=head2 prepare

Creates the required database update and deployment files.
Update is from current database version to current schema version.

=head2 update

Deploys or updates the database to the current schema version.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
