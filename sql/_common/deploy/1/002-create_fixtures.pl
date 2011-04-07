use Modern::Perl;

use File::Slurp (qw/ slurp /);
use Tipping::Populator ();

sub {
    my $schema = shift;

    for my $yaml (qw/ teams venues games /) {
        Tipping::Populator::populate(
            schema  => $schema,
            yaml    => scalar slurp("yaml/2011/$yaml.yml"),
#            verbose => 1,
        );
    }
}
