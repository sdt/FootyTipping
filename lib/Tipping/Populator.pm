package Tipping::Populator;

use Modern::Perl;

use Data::Dumper::Concise (qw/ Dumper /);
use List::MoreUtils (qw/ zip /);
use Params::Validate (qw/ validate :types /);
use YAML::XS ();

sub populate {
    my %args = validate(@_, {
            schema => {
                isa => 'DBIx::Class::Schema',
            },
            yaml => {
                type => SCALAR,
            },
            verbose => {
                type => SCALAR,
                optional => 1,
            },
        });

    my ($data) = YAML::XS::Load($args{yaml});
    say STDERR Dumper($data) if $args{verbose};

    for my $row (@{ $data->{insert} }) {
        $args{schema}->resultset($data->{table})->create({
            zip @{ $data->{columns} }, @{ $row }
        });
    }
}

1;
