package Tipping::WebApp::View::HTML;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

Tipping::WebApp::View::HTML - TT View for Tipping::WebApp

=head1 DESCRIPTION

TT View for Tipping::WebApp.

=head1 SEE ALSO

L<Tipping::WebApp>

=head1 AUTHOR

Stephen Thirlwall,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
