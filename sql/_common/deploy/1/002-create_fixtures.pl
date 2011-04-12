use Modern::Perl;

use Data::Dumper::Concise   (qw/ Dumper /);
use File::Slurp             (qw/ slurp  /);
use Hash::MoreUtils         (qw/ slice  /);
use Tipping::Populator      ();
use YAML::XS                (qw/ LoadFile /);

sub {
    my $schema = shift;

    for my $yaml_file (qw{ teams venues }) {
        Tipping::Populator::populate(
            schema  => $schema,
            yaml    => scalar slurp("yaml/$yaml_file.yml"),
#           verbose => 1,
        );
    }

    my ($data) = YAML::XS::LoadFile('yaml/2011/games.yml');
    my $games = $schema->resultset('Game');
    my $teams = $schema->resultset('Team');
    for my $game_info (@{ $data->{create} }) {
        my $game = $games->create({ slice($game_info,
                qw/ season round venue start_time_utc /
            ) });
        $game->add_to_teams($game_info->{home_team}, { is_home_team => 1 });
        #$game->add_to_teams($game_info->{home_team}, { is_home_team => 0 });
        my $func = 'add_to_teams';
        $game->$func($game_info->{away_team}, { is_home_team => 0 });
    }
}
