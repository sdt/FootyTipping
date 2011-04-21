package Tipping::WebApp::Controller::Root;
use Modern::Perl;
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

    # Hello World
    $c->response->body( $c->welcome_message );

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

=head2 hello_user

Login stub test thingy

=cut

sub hello_user : Local Does('NeedsLogin') {
    my ( $self, $c ) = @_;
    $c->response->body('<h2>Hello, ' . $c->user->real_name . '!</h2>');
    return;
}

=head2 hello_user2

Login stub test thingy

=cut

sub hello_user2 : Local Does('NeedsLogin') {
    my ( $self, $c ) = @_;
    $c->response->body('<h2>Hello2, ' . $c->user->real_name . '!</h2>');
    return;
}

=head1 AUTHOR

Stephen Thirlwall,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
