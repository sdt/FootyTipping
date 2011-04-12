#!/usr/bin/env perl

use Modern::Perl;

use autodie;
use List::MoreUtils qw/ zip /;
use DateTime::Format::DateParse;

my $round;
my $month;
my $timezone;
my $day_of_month;

my $venue_regex = join('|', qw(
    Cazaly's\sStadium Docklands\sStadium Football\sPark Gabba
    Gold\sCoast\sStadium Kardinia\sPark Manuka\sOval Marrara\sOval MCG SCG
    Stadium\sAustralia Subiaco\sOval York\sPark
));

my @month_names = qw/
    January February March April May June
    July August September October November December
/;
my @month_numbers = (1 .. 12);
my %month_number = zip @month_names, @month_numbers;

my $time_regex = qr(\d+:\d\dpm);

my $outfile = 'yaml/2011/games.yml';
open my $out, '>', $outfile;


say {$out} 'table: Game';
say {$out} 'create_and_add_many:';

while (<DATA>) {
    chomp;

    given ($_) {

        when (/^
                Round
                    \s+
                (\d+)
               $/x) {
            $round = $1;
        }

        when (/^
                [A-Z][a-z]+,
                    \s+
                ([A-Z][a-z]+)
                    \s+
                (\d+)
                    .*?
                (EST|EDT)\s+LOCAL\s+TIME
              /x) {
            $month        = $month_number{$1};
            $day_of_month = $2;
            $timezone     = $3;
        }

        when (/^
                [A-Z][a-z]+,
                    \s+
                ([A-Z][a-z]+)
                    \s+
                (\d+)
              /x) {
            $month        = $month_number{$1};
            $day_of_month = $2;
        }

        when (/^
                (.+)
                    \s+
                vs\.
                    \s+
                (.+)
                    \s+
                ($venue_regex)
                    \s+
                TBC
                    \s+
                TBC
                    \s+
                TBC
               $/x) {
            my ($home_team, $away_team, $venue) = ($1, $2, $3);
            _emit_round($out, $round, $home_team, $away_team, $venue);
        }

        when (/^
                (.+)
                    \s+
                vs\.
                    \s+
                (.+)
                    \s+
                ($venue_regex)
                    \s+
                ($time_regex)
                    \s+
                ($time_regex)
                    \s+
                ([A-Z]+)
               $/x) {

            my ($home_team, $away_team, $venue, $melb_time, $local_time,
                $network) = ($1, $2, $3, $4, $5, $6);
            _emit_round($out, $round, $home_team, $away_team, $venue, $melb_time, $timezone);
        }

        when (/^Byes?:/) {
            # nothing
        }

        default {
            die "Unexpected: $_";
        }
    }
}

sub _emit_round {
    my ($out, $round, $home_team, $away_team, $venue, $melb_time, $timezone) = @_;

    my $dt;
    if (defined $melb_time) {
        $dt = DateTime::Format::DateParse->parse_datetime( $melb_time, 'Australia/Melbourne' );
        if ($timezone eq 'EDT') {
            $dt->subtract( hours => 1);
        }
        $dt->set_month($month);
        $dt->set_day($day_of_month);
    }
    else {
        $dt = DateTime->new(year => 2011, month => 9, day => 2);
    }
    $dt->set_time_zone('UTC');

    say {$out} '  - create:';
    say {$out} '      season: 2011';
    say {$out} "      round: $round";
    say {$out} '      venue:';
    say {$out} "        name: $venue";
    say {$out} "      start_time_utc: $dt";
    say {$out} '    add_many:';
    say {$out} '      relation: teams';
    say {$out} '      values:';
    say {$out} '        - search:';
    say {$out} "            name: $home_team";
    say {$out} '          extra:';
    say {$out} '            is_home_team: 1';
    say {$out} '        - search:';
    say {$out} "            name: $away_team";
    say {$out} '          extra:';
    say {$out} '            is_home_team: 0';

    $dt->set_time_zone('Australia/Melbourne');
}

__DATA__
Round 1
Thursday, March 24 VENUE EDT LOCAL TIME NETWORK
Carlton vs. Richmond MCG 7:10pm 7:10pm TEN
Friday, March 25
Geelong vs. St Kilda MCG 7:40pm 7:40pm SEVEN
Saturday, March 26
Collingwood vs. Port Adelaide Docklands Stadium 2:10pm 2:10pm FOX
Adelaide vs. Hawthorn Football Park 8:40pm 7:10pm TEN
Brisbane vs. Fremantle Gabba 8:10pm 7:10pm FOX
Sunday, March 27
Essendon vs. Western Bulldogs Docklands Stadium 1:10pm 1:10pm FOX
Melbourne vs. Sydney MCG 2:10pm 2:10pm SEVEN
West Coast vs. North Melbourne Subiaco Oval 7:10pm 4:10pm FOX
Bye: Gold Coast
Round 2
Friday, April 1 VENUE EDT LOCAL TIME NETWORK
St Kilda vs. Richmond MCG 7:40pm 7:40pm SEVEN
Saturday, April 2
North Melbourne vs. Collingwood Docklands Stadium 2:10pm 2:10pm TEN
Port Adelaide vs. West Coast Football Park 3:10pm 2:40pm FOX
Gold Coast vs. Carlton Gabba 7:40pm 6:40pm TEN
Fremantle vs. Geelong Subiaco Oval 8:40pm 5:40pm FOX
Sunday, April 3 EST LOCAL TIME
Western Bulldogs vs. Brisbane Docklands Stadium 1:10pm 1:10pm FOX
Sydney vs. Essendon Stadium Australia 2:10pm 2:10pm SEVEN
Hawthorn vs. Melbourne MCG 4:40pm 4:40pm FOX
Bye: Adelaide
Round 3
Friday, April 8 VENUE EST LOCAL TIME NETWORK
Collingwood vs. Carlton MCG 7:40pm 7:40pm SEVEN
Saturday, April 9
Western Bulldogs vs. Gold Coast Docklands Stadium 2:10pm 2:10pm TEN
Adelaide vs. Fremantle Football Park 3:10pm 2:40pm FOX
Richmond vs. Hawthorn MCG 7:10pm 7:10pm TEN
West Coast vs. Sydney Subiaco Oval 7:40pm 5:40pm FOX
Sunday, April 10
Melbourne vs. Brisbane MCG 1:10pm 1:10pm FOX
Geelong vs. Port Adelaide Kardinia Park 2:10pm 2:10pm SEVEN
St Kilda vs. Essendon Docklands Stadium 4:40pm 4:40pm FOX
Bye: North Melbourne
Round 4
Friday, April 15 VENUE EST LOCAL TIME NETWORK
Richmond vs. Collingwood MCG 7:40pm 7:40pm SEVEN
Saturday, April 16
Hawthorn vs. West Coast York Park 2:10pm 2:10pm FOX
Carlton vs. Essendon MCG 2:10pm 2:10pm TEN
Sydney vs. Geelong SCG 7:10pm 7:10pm TEN
Port Adelaide vs. Adelaide Football Park 7:40pm 7:10pm FOX
Sunday, April 17
Gold Coast vs. Melbourne Gabba 2:10pm 2:10pm SEVEN
Fremantle vs. North Melbourne Subiaco Oval 4:40pm 2:40pm FOX
Byes: Brisbane, St Kilda, Western Bulldogs
Round 5
Thursday, April 21 VENUE EST LOCAL TIME NETWORK
Brisbane vs. St Kilda Gabba 7:40pm 7:40pm SEVEN
Saturday, April 23
Port Adelaide vs. Gold Coast Football Park 3:10pm 2:40pm FOX
Carlton vs. Adelaide Docklands Stadium 7:10pm 7:10pm TEN
Sunday, April 24
North Melbourne vs. Richmond Docklands Stadium 4:40pm 4:40pm FOX
Monday, April 25
Essendon vs. Collingwood MCG 2:40pm 2:40pm TEN
Fremantle vs. Western Bulldogs Subiaco Oval 8:40pm 6:40pm FOX
Tuesday, April 26
Hawthorn vs. Geelong MCG 2:40pm 2:40pm SEVEN
Byes: Melbourne, Sydney, West Coast
Round 6
Thursday, April 28 VENUE EST LOCAL TIME NETWORK
West Coast vs. Melbourne Subiaco Oval 8:40pm 6:40pm TEN
Friday, April 29
Sydney vs. Carlton SCG 7:40pm 7:40pm SEVEN
Saturday, April 30
North Melbourne vs. Port Adelaide Docklands Stadium 2:10pm 2:10pm FOX
Richmond vs. Brisbane MCG 7:10pm 7:10pm FOX
Adelaide vs. St Kilda Football Park 7:40pm 7:10pm TEN
Sunday, May 1
Essendon vs. Gold Coast Docklands Stadium 1:10pm 1:10pm FOX
Collingwood vs. Western Bulldogs MCG 4:40pm 4:40pm FOX
Byes: Fremantle, Geelong, Hawthorn
Round 7
Friday, May 6 VENUE EST LOCAL TIME NETWORK
Port Adelaide vs. Hawthorn Football Park 8:40pm 8:10pm SEVEN
Saturday, May 7
Western Bulldogs vs. Sydney Manuka Oval 1:10pm 1:10pm FOX
Geelong vs. North Melbourne Kardinia Park 2:10pm 2:10pm TEN
Richmond vs. Fremantle MCG 4:10pm 4:10pm FOX
Gold Coast vs. Brisbane Gabba 7:10pm 7:10pm FOX
Sunday, May 8
Essendon vs. West Coast Docklands Stadium 1:10pm 1:10pm FOX
Melbourne vs. Adelaide MCG 2:10pm 2:10pm SEVEN
Monday, May 9
St Kilda vs. Carlton Docklands Stadium 7:20pm 7:20pm TEN
Bye: Collingwood
Round 8
Friday, May 13 VENUE EST LOCAL TIME NETWORK
Geelong vs. Collingwood MCG 7:40pm 7:40pm SEVEN
Saturday, May 14
North Melbourne vs. Melbourne Docklands Stadium 2:10pm 2:10pm TEN
Adelaide vs. Gold Coast Football Park 3:10pm 2:40pm FOX
Brisbane vs. Essendon Gabba 7:10pm 7:10pm TEN
Sydney vs. Port Adelaide SCG 7:10pm 7:10pm FOX
Sunday, May 15
Hawthorn vs. St Kilda MCG 1:10pm 1:10pm FOX
Western Bulldogs vs. Richmond Docklands Stadium 2:10pm 2:10pm SEVEN
West Coast vs. Fremantle Subiaco Oval 4:40pm 2:40pm FOX
Bye: Carlton
Round 9
Friday, May 20 VENUE EST LOCAL TIME NETWORK
Carlton vs. Geelong Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, May 21
St Kilda vs. Melbourne Docklands Stadium 2:10pm 2:10pm TEN
Port Adelaide vs. Fremantle Football Park 3:10pm 2:40pm FOX
Brisbane vs. North Melbourne Gabba 7:10pm 7:10pm FOX
Richmond vs. Essendon MCG 7:40pm 7:40pm TEN
Sunday, May 22
Collingwood vs. Adelaide Docklands Stadium 1:10pm 1:10pm FOX
Sydney vs. Hawthorn SCG 2:10pm 2:10pm SEVEN
West Coast vs. Western Bulldogs Subiaco Oval 4:40pm 2:40pm FOX
Bye: Gold Coast
Round 10
Friday, May 27 VENUE EST LOCAL TIME NETWORK
Melbourne vs. Carlton MCG 7:40pm 7:40pm SEVEN
Saturday, May 28
North Melbourne vs. Sydney Docklands Stadium 2:10pm 2:10pm FOX
Fremantle vs. St Kilda Subiaco Oval 3:10pm 1:10pm TEN
Gold Coast vs. Geelong Gold Coast Stadium 7:10pm 7:10pm TEN
Richmond vs. Port Adelaide Marrara Oval 8:40pm 8:10pm FOX
Sunday, May 29
Adelaide vs. Brisbane Football Park 1:10pm 12:40pm FOX
Collingwood vs. West Coast MCG 2:10pm 2:10pm SEVEN
Western Bulldogs vs. Hawthorn Docklands Stadium 4:40pm 4:40pm FOX
Bye: Essendon
Round 11
Friday, June 3 VENUE EST LOCAL TIME NETWORK
Essendon vs. Melbourne MCG 7:40pm 7:40pm SEVEN
Saturday, June 4
Geelong vs. Western Bulldogs Kardinia Park 2:10pm 2:10pm TEN
West Coast vs. Gold Coast Subiaco Oval 3:10pm 1:10pm FOX
Brisbane vs. Sydney Gabba 7:10pm 7:10pm FOX
Collingwood vs. St Kilda MCG 7:10pm 7:10pm TEN
Sunday, June 5
Hawthorn vs. Fremantle MCG 1:10pm 1:10pm FOX
North Melbourne vs. Adelaide Docklands Stadium 2:10pm 2:10pm SEVEN
Port Adelaide vs. Carlton Football Park 4:40pm 4:10pm FOX
Bye: Richmond
Round 12
Friday, June 10 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Western Bulldogs Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, June 11
Adelaide vs. West Coast Football Park 3:10pm 2:40pm FOX
Gold Coast vs. North Melbourne Gold Coast Stadium 7:10pm 7:10pm FOX
Geelong vs. Hawthorn MCG 7:10pm 7:10pm TEN
Sunday, June 12
Carlton vs. Brisbane Docklands Stadium 1:10pm 1:10pm FOX
Sydney vs. Richmond SCG 2:10pm 2:10pm SEVEN
Fremantle vs. Essendon Subiaco Oval 4:40pm 2:40pm FOX
Monday, June 13
Melbourne vs. Collingwood MCG 2:10pm 2:10pm TEN
Bye: Port Adelaide
Round 13
Friday, June 17 VENUE EST LOCAL TIME NETWORK
Western Bulldogs vs. Adelaide Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, June 18
Hawthorn vs. Gold Coast York Park 2:10pm 2:10pm TEN
Essendon vs. North Melbourne Docklands Stadium 2:10pm 2:10pm FOX
Brisbane vs. Richmond Gabba 7:10pm 7:10pm FOX
St Kilda vs. Geelong MCG 7:10pm 7:10pm TEN
Sunday, June 19
Melbourne vs. Fremantle MCG 1:10pm 1:10pm FOX
Carlton vs. Sydney Docklands Stadium 2:10pm 2:10pm SEVEN
West Coast vs. Port Adelaide Subiaco Oval 4:40pm 2:40pm FOX
Bye: Collingwood
Round 14
Friday, June 24 VENUE EST LOCAL TIME NETWORK
Hawthorn vs. Essendon MCG 7:40pm 7:40pm SEVEN
Saturday, June 25
Gold Coast vs. Western Bulldogs Gold Coast Stadium 2:10pm 2:10pm TEN
Richmond vs. Melbourne MCG 2:10pm 2:10pm FOX
Sydney vs. Collingwood Stadium Australia 7:10pm 7:10pm TEN
Fremantle vs. Brisbane Subiaco Oval 7:40pm 5:40pm FOX
Sunday, June 26
Geelong vs. Adelaide Kardinia Park 1:10pm 1:10pm FOX
Carlton vs. West Coast Docklands Stadium 2:10pm 2:10pm SEVEN
Port Adelaide vs. North Melbourne Football Park 4:40pm 4:10pm FOX
Bye: St Kilda
Round 15
Friday, July 1 VENUE EST LOCAL TIME NETWORK
Western Bulldogs vs. Melbourne Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, July 2
Richmond vs. Carlton MCG 2:10pm 2:10pm TEN
Fremantle vs. Gold Coast Subiaco Oval 3:10pm 1:10pm FOX
Essendon vs. Geelong Docklands Stadium 7:10pm 7:10pm TEN
Adelaide vs. Sydney Football Park 7:40pm 7:10pm FOX
Sunday, July 3
Brisbane vs. Port Adelaide Gabba 1:10pm 1:10pm FOX
Collingwood vs. Hawthorn MCG 2:10pm 2:10pm SEVEN
North Melbourne vs. St Kilda Docklands Stadium 4:40pm 4:40pm FOX
Bye: West Coast
Round 16
Friday, July 8 VENUE EST LOCAL TIME NETWORK
West Coast vs. Geelong Subiaco Oval 8:40pm 6:40pm SEVEN
Saturday, July 9
Hawthorn vs. Brisbane York Park 2:10pm 2:10pm FOX
Gold Coast vs. Sydney Gold Coast Stadium 7:10pm 7:10pm FOX
Essendon vs. Richmond MCG 7:10pm 7:10pm TEN
Sunday, July 10
Collingwood vs. North Melbourne MCG 1:10pm 1:10pm FOX
Port Adelaide vs. St Kilda Football Park 3:10pm 2:40pm SEVEN
Western Bulldogs vs. Carlton Docklands Stadium 4:40pm 4:40pm FOX
Byes: Adelaide, Fremantle, Melbourne
Round 17
Friday, July 15 VENUE EST LOCAL TIME NETWORK
Adelaide vs. Essendon Football Park 8:40pm 8:10pm SEVEN
Saturday, July 16
Richmond vs. Gold Coast Cazaly's Stadium 2:10pm 2:10pm FOX
Carlton vs. Collingwood MCG 2:10pm 2:10pm TEN
St Kilda vs. West Coast Docklands Stadium 7:10pm 7:10pm FOX
Melbourne vs. Port Adelaide Marrara Oval 8:40pm 8:10pm TEN
Sunday, July 17
Sydney vs. Fremantle SCG 1:10pm 1:10pm FOX
Brisbane vs. Geelong Gabba 2:10pm 2:10pm SEVEN
North Melbourne vs. Western Bulldogs Docklands Stadium 4:40pm 4:40pm FOX
Bye: Hawthorn
Round 18
Friday, July 22 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Adelaide Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, July 23
North Melbourne vs. Brisbane Docklands Stadium 2:10pm 2:10pm TEN
Sydney vs. Western Bulldogs SCG 2:10pm 2:10pm FOX
Gold Coast vs. Collingwood Gold Coast Stadium 7:10pm 7:10pm FOX
Essendon vs. Carlton MCG 7:10pm 7:10pm TEN
Sunday, July 24
Geelong vs. Richmond Docklands Stadium 1:10pm 1:10pm FOX
Melbourne vs. Hawthorn MCG 2:10pm 2:10pm SEVEN
Fremantle vs. West Coast Subiaco Oval 4:40pm 2:40pm FOX
Bye: Port Adelaide
Round 19
Friday, July 29 VENUE EST LOCAL TIME NETWORK
North Melbourne vs. Carlton Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, July 30
Western Bulldogs vs. West Coast Docklands Stadium 2:10pm 2:10pm TEN
Geelong vs. Melbourne Kardinia Park 2:10pm 2:10pm FOX
Gold Coast vs. St Kilda Gold Coast Stadium 7:10pm 7:10pm FOX
Fremantle vs. Hawthorn Subiaco Oval 7:40pm 5:40pm TEN
Sunday, July 31
Collingwood vs. Essendon MCG 2:10pm 2:10pm SEVEN
Adelaide vs. Port Adelaide Football Park 4:40pm 4:10pm FOX
Byes: Brisbane, Richmond, Sydney
Round 20
Friday, August 5 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Fremantle Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, August 6
Carlton vs. Melbourne MCG 2:10pm 2:10pm TEN
Geelong vs. Gold Coast Kardinia Park 2:10pm 2:10pm FOX
Essendon vs. Sydney Docklands Stadium 7:10pm 7:10pm FOX
Port Adelaide vs. Collingwood Football Park 7:40pm 7:10pm TEN
Sunday, August 7
Brisbane vs. Adelaide Gabba 1:10pm 1:10pm FOX
Hawthorn vs. North Melbourne York Park 2:10pm 2:10pm SEVEN
West Coast vs. Richmond Subiaco Oval 4:40pm 2:40pm FOX
Bye: Western Bulldogs
Round 21
Friday, August 12 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Collingwood Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, August 13
Hawthorn vs. Port Adelaide MCG 2:10pm 2:10pm TEN
Fremantle vs. Carlton Subiaco Oval 3:10pm 1:10pm FOX
Western Bulldogs vs. Essendon Docklands Stadium 7:10pm 7:10pm TEN
Brisbane vs. Gold Coast Gabba 7:10pm 7:10pm FOX
Sunday, August 14
Melbourne vs. West Coast Docklands Stadium 1:10pm 1:10pm FOX
Richmond vs. Sydney MCG 2:10pm 2:10pm SEVEN
Adelaide vs. Geelong Football Park 4:40pm 4:10pm FOX
Bye: North Melbourne
Round 22
Friday, August 19 VENUE EST LOCAL TIME NETWORK
Carlton vs. Hawthorn Docklands Stadium 7:40pm 7:40pm SEVEN
Saturday, August 20
Gold Coast vs. Adelaide Gold Coast Stadium 2:10pm 2:10pm FOX
West Coast vs. Essendon Subiaco Oval 3:10pm 1:10pm TEN
North Melbourne vs. Fremantle Docklands Stadium 7:10pm 7:10pm FOX
Collingwood vs. Brisbane MCG 7:10pm 7:10pm TEN
Sunday, August 21
Sydney vs. St Kilda Stadium Australia 1:10pm 1:10pm FOX
Port Adelaide vs. Western Bulldogs Football Park 3:10pm 2:40pm SEVEN
Melbourne vs. Richmond MCG 4:40pm 4:40pm FOX
Bye: Geelong
Round 23
Friday, August 26 VENUE EST LOCAL TIME NETWORK
Fremantle vs. Collingwood Subiaco Oval 8:40pm 6:40pm SEVEN
Saturday, August 27
Hawthorn vs. Western Bulldogs MCG 2:10pm 2:10pm TEN
Geelong vs. Sydney Kardinia Park 2:10pm 2:10pm FOX
St Kilda vs. North Melbourne Docklands Stadium 7:10pm 7:10pm TEN
Brisbane vs. West Coast Gabba 7:10pm 7:10pm FOX
Sunday, August 28
Adelaide vs. Richmond Football Park 1:10pm 12:40pm FOX
Melbourne vs. Gold Coast MCG 2:10pm 2:10pm SEVEN
Essendon vs. Port Adelaide Docklands Stadium 4:40pm 4:40pm FOX
Bye: Carlton
Round 24
Friday, September 2 - Sunday, September 4 VENUE EST LOCAL TIME NETWORK
Carlton vs. St Kilda MCG TBC TBC TBC
Port Adelaide vs. Melbourne Football Park TBC TBC TBC
Western Bulldogs vs. Fremantle Docklands Stadium TBC TBC TBC
Sydney vs. Brisbane SCG TBC TBC TBC
West Coast vs. Adelaide Subiaco Oval TBC TBC TBC
Collingwood vs. Geelong MCG TBC TBC TBC
Richmond vs. North Melbourne Docklands Stadium TBC TBC TBC
Gold Coast vs. Hawthorn Gold Coast Stadium TBC TBC TBC
Bye: Essendon
