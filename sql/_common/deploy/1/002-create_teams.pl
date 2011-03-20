use Modern::Perl;

use File::Slurp (qw/ slurp /);
use Tipping::Populator ();

sub {
    my $schema = shift;

    Tipping::Populator::populate(
        schema  => $schema,
        yaml    => scalar slurp('yaml/teams-2011.yml'),
    );
}
