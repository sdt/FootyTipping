package Tipping::WebApp;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

use Tipping::Config ();

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    Authentication
    Session
    Session::State::Cookie
    Session::Store::DBIC
    Static::Simple

    +CatalystX::SimpleLogin
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in tipping.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Tipping',

    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,

    authentication => {
        default_realm => 'database',
        realms => {
            database => {
                credential => {
                    class => 'Password',
                    password_field => 'password',
                    password_type => 'clear', #TODO: sha-1
                },
                store => {
                    class => 'DBIx::Class',
                    user_model => 'DB::User',
                },
            },
        },
    },

    session => {
        dbic_class      => 'DB::Session',
        expires         => 60 * 60,
        id_field        => 'session_id',
        data_field      => 'session_data',
        flash_to_stash  => 1,
    },

    #'Controller::Login' => { traits => 'Login::WithRedirect', },
    #'Contoller::Login' => { traits => 'Login::WithRedirect' }
);
    # Finally, load up the config file stuff
__PACKAGE__->config( Tipping::Config->config );

# Start the application
__PACKAGE__->setup();

1;

__END__

=pod

=head1 NAME

Tipping - Catalyst based application

=head1 SYNOPSIS

    script/tipping_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Tipping::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Stephen Thirlwall,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
