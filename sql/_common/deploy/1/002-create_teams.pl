use Modern::Perl;

use Tipping::Populator ();

sub {
    my $schema = shift;

my $yaml = <<'END_YAML';
---
table: Team
columns:
  - name
  - nickname
rows:
  -
    - Adelaide
    - Crows
  -
    - Brisbane
    - Lions
  -
    - Carlton
    - Blues
  -
    - Collingwood
    - Mapgies
  -
    - Essendon
    - Bombers
  -
    - Fremantle
    - Dockers
  -
    - Geelong
    - Cats
  -
    - Gold Coast
    - Suns
  -
    - Hawthorn
    - Hawks
  -
    - Melbourne
    - Demons
  -
    - North Melbourne
    - Kangaroos
  -
    - Port Adelaide
    - Power
  -
    - Richmond
    - Tigers
  -
    - St Kilda
    - Saints
  -
    - Sydney
    - Swans
  -
    - West Coast
    - Eagles
  -
    - Western
    - Bulldogs
END_YAML

    Tipping::Populator::populate(
        schema  => $schema,
        yaml    => $yaml
    );
}
