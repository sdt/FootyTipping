package Tipping::WebApp::Model::Scores;
use base 'Catalyst::Model::Adaptor';

__PACKAGE__->config( class => 'Tipping::Scores' );

sub prepare_arguments {
    my ($self, $app) = @_;

    return { schema => $app->model('DB')->schema }
}

1;

__END__

=pod

=head1 NAME

Tipping::WebApp::Model::Scores - Catalyst model for Tipping::Scores

=head1 SYNOPSIS

$scores = $c->model('Scores');

=head1 METHODS

=head2 prepare_arguments

Called internally at application setup time.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
