package Tipping::WebApp::Model::DB;

use Modern::Perl;
use base 'Catalyst::Model::DBIC::Schema';

use Tipping::Config;

__PACKAGE__->config(
    schema_class => 'Tipping::Schema',
    connect_info => Tipping::Config->config->{database},
);

1;

__END__

=pod

=head1 NAME

Tipping::WebApp::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Tipping::WebApp>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Tipping::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.43

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
