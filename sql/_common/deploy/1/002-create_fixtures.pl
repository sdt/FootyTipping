use Modern::Perl;

use Data::Dumper::Concise   (qw/ Dumper /);
use File::Slurp             (qw/ slurp  /);
use Hash::MoreUtils         (qw/ slice  /);
use Tipping::Populator      ();
use YAML::XS                (qw/ LoadFile /);

sub {
    my $schema = shift;

    for my $yaml_file (qw{ teams venues 2011/games 2011/results }) {
        Tipping::Populator::populate(
            schema  => $schema,
            yaml    => scalar slurp("yaml/$yaml_file.yml"),
#           verbose => 1,
        );
    }
}
