package Tipping::Schema::Result;
use parent 'DBIx::Class';

use Modern::Perl::5_14;


sub _data_dumper_hook {     ## no critic (ProhibitUnusedPrivateSubroutines)
    return $_[0] = bless {
        %{ $_[0] },
        _source_handle => undef,
        _result_source => undef,
    }, ref($_[0]);
}

1;

__END__

=pod

=head1 NAME

Tipping::Schema::Result - DBIx::Class result base class

=head1 DESCRIPTION

Common base class for result classes.

=head1 METHODS

=head2 _data_dumper_hook

Internal function to make Data::Dumper output less verbose when printing
DBIx::Class classes.

=head1 AUTHOR

Stephen Thirlwall <sdt@dr.com>

=cut
