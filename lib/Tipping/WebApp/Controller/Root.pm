package Tipping::WebApp::Controller::Root;
use Modern::Perl::5_14;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::ActionRole' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

Tipping::Controller::Root - Root Controller for Tipping

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {      ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;

    if (not $c->user_exists) {
        $c->response->redirect($c->uri_for('/login'));
    }
    $c->response->redirect($c->uri_for('/tips/view'));

    return;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {             ## no critic (ProhibitBuiltinHomonyms)
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);  ## no critic (ProhibitMagicNumbers)
    return;
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Stephen Thirlwall,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
