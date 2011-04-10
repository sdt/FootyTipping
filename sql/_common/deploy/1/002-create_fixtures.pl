use Modern::Perl;

use File::Slurp (qw/ slurp /);
use Tipping::Populator ();

sub {
    my $schema = shift;

    for my $yaml (qw{ teams venues 2011/games 2011/results }) {
        Tipping::Populator::populate(
            schema  => $schema,
            yaml    => scalar slurp("yaml/$yaml.yml"),
#           verbose => 1,
        );
    }
}
