use Modern::Perl;

use File::Slurp (qw/ slurp /);
use Tipping::Populator ();

sub {
    my $schema = shift;

    for my $yaml (qw{ teams venues 2011/games }) {
        Tipping::Populator::populate(
            schema  => $schema,
            yaml    => scalar slurp("yaml/$yaml.yml"),
#            verbose => 1,
        );
    }
}
