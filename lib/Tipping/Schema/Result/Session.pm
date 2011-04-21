package Tipping::Schema::Result::Session;
use parent 'DBIx::Class';

use Modern::Perl;

__PACKAGE__->load_components('Core');
__PACKAGE__->table('tbl_session');
__PACKAGE__->add_columns(
    session_id => {
        data_type           => 'char',
        size                => 72,
        is_nullable         => 0,
    },
    session_data => {
        data_type           => 'text',
        is_nullable         => 1,
    },
    expires => {
        data_type           => 'integer',
        is_nullable         => 1,
    },
);

__PACKAGE__->set_primary_key('session_id');

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result::Session - DBIx::Class result source

=head1 DESCRIPTION

Catalyst::Plugin::Session::Store::DBIC table.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
