package Tipping::DeploymentHandler;

use Modern::Perl;
use DBIx::Class::DeploymentHandler;
use SQL::Translator;
use Moose;

has schema => (
    is  => 'ro',
    isa => 'DBIx::Class::Schema',
);

has deployment_handler => (
    is          => 'ro',
    isa         => 'DBIx::Class::DeploymentHandler',
    lazy_build  => 1,
);

sub _build_deployment_handler {
    my $self = shift;

    my $dh = DBIx::Class::DeploymentHandler->new( {
        schema              => $self->schema,
        databases           => [qw/ SQLite PostgreSQL MySQL /],
        sql_translator_args => { add_drop_table => 0, },
        force_overwrite     => 1,
    } );

    return $dh;
}

sub prepare {
    my $self = shift;

    $self->deployment_handler->prepare_install;

    my $version = $self->schema->VERSION;

    if ($version > 1) {
        $self->deployment_handler->prepare_upgrade({
                from_version => $version - 1,
                to_version   => $version,
                version_set  => [ $version - 1, $version ],
            });

        $self->deployment_handler->prepare_downgrade({
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
}

no Moose;
__PACKAGE__->meta->make_immutable();
1;
