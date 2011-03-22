#!/usr/bin/env perl

use Modern::Perl;

use autodie;
use List::MoreUtils qw/ zip /;

my $round;
my $month;
my $day_of_month;

my $venue_regex = join('|', qw/
    AAMI\sStadium ANZ\sStadium Aurora\sStadium Cazaly's\sStadium
    Etihad\sStadium Gabba Gold\sCoast\sStadium Manuka\sOval MCG
    Patersons\sStadium SCG Skilled\sStadium TIO\sStadium
/);

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
say {$out} 'rows:';

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
            _emit_round($out, $round, $home_team, $away_team, $venue);
        }

        when (/^Byes?:/) {
            # nothing
        }

        default {
            die "Unexpected: $_";
        }
    }
}

my @columns = qw/ round home_team:name away_team:name venuej:sponsor_name /;
sub _emit_round {
    my ($out, $round, $home_team, $away_team, $venue) = @_;
    say {$out} '  -';
    say {$out} "    round: $round";
    say {$out} "    home_team:";
    say {$out} "      name: $home_team";
    say {$out} "    away_team:";
    say {$out} "      name: $away_team";
    say {$out} "    venue:";
    say {$out} "      sponsor_name: $venue";
}

__DATA__
Round 1
Thursday, March 24 VENUE EDT LOCAL TIME NETWORK
Carlton vs. Richmond MCG 7:10pm 7:10pm TEN
Friday, March 25
Geelong vs. St Kilda MCG 7:40pm 7:40pm SEVEN
Saturday, March 26
Collingwood vs. Port Adelaide Etihad Stadium 2:10pm 2:10pm FOX
Adelaide vs. Hawthorn AAMI Stadium 8:40pm 7:10pm TEN
Brisbane vs. Fremantle Gabba 8:10pm 7:10pm FOX
Sunday, March 27
Essendon vs. Western Bulldogs Etihad Stadium 1:10pm 1:10pm FOX
Melbourne vs. Sydney MCG 2:10pm 2:10pm SEVEN
West Coast vs. North Melbourne Patersons Stadium 7:10pm 4:10pm FOX
Bye: Gold Coast
Round 2
Friday, April 1 VENUE EDT LOCAL TIME NETWORK
St Kilda vs. Richmond MCG 7:40pm 7:40pm SEVEN
Saturday, April 2
North Melbourne vs. Collingwood Etihad Stadium 2:10pm 2:10pm TEN
Port Adelaide vs. West Coast AAMI Stadium 3:10pm 2:40pm FOX
Gold Coast vs. Carlton Gabba 7:40pm 6:40pm TEN
Fremantle vs. Geelong Patersons Stadium 8:40pm 5:40pm FOX
Sunday, April 3 EST LOCAL TIME
Western Bulldogs vs. Brisbane Etihad Stadium 1:10pm 1:10pm FOX
Sydney vs. Essendon ANZ Stadium 2:10pm 2:10pm SEVEN
Hawthorn vs. Melbourne MCG 4:40pm 4:40pm FOX
Bye: Adelaide
Round 3
Friday, April 8 VENUE EST LOCAL TIME NETWORK
Collingwood vs. Carlton MCG 7:40pm 7:40pm SEVEN
Saturday, April 9
Western Bulldogs vs. Gold Coast Etihad Stadium 2:10pm 2:10pm TEN
Adelaide vs. Fremantle AAMI Stadium 3:10pm 2:40pm FOX
Richmond vs. Hawthorn MCG 7:10pm 7:10pm TEN
West Coast vs. Sydney Patersons Stadium 7:40pm 5:40pm FOX
Sunday, April 10
Melbourne vs. Brisbane MCG 1:10pm 1:10pm FOX
Geelong vs. Port Adelaide Skilled Stadium 2:10pm 2:10pm SEVEN
St Kilda vs. Essendon Etihad Stadium 4:40pm 4:40pm FOX
Bye: North Melbourne
Round 4
Friday, April 15 VENUE EST LOCAL TIME NETWORK
Richmond vs. Collingwood MCG 7:40pm 7:40pm SEVEN
Saturday, April 16
Hawthorn vs. West Coast Aurora Stadium 2:10pm 2:10pm FOX
Carlton vs. Essendon MCG 2:10pm 2:10pm TEN
Sydney vs. Geelong SCG 7:10pm 7:10pm TEN
Port Adelaide vs. Adelaide AAMI Stadium 7:40pm 7:10pm FOX
Sunday, April 17
Gold Coast vs. Melbourne Gabba 2:10pm 2:10pm SEVEN
Fremantle vs. North Melbourne Patersons Stadium 4:40pm 2:40pm FOX
Byes: Brisbane, St Kilda, Western Bulldogs
Round 5
Thursday, April 21 VENUE EST LOCAL TIME NETWORK
Brisbane vs. St Kilda Gabba 7:40pm 7:40pm SEVEN
Saturday, April 23
Port Adelaide vs. Gold Coast AAMI Stadium 3:10pm 2:40pm FOX
Carlton vs. Adelaide Etihad Stadium 7:10pm 7:10pm TEN
Sunday, April 24
North Melbourne vs. Richmond Etihad Stadium 4:40pm 4:40pm FOX
Monday, April 25
Essendon vs. Collingwood MCG 2:40pm 2:40pm TEN
Fremantle vs. Western Bulldogs Patersons Stadium 8:40pm 6:40pm FOX
Tuesday, April 26
Hawthorn vs. Geelong MCG 2:40pm 2:40pm SEVEN
Byes: Melbourne, Sydney, West Coast
Round 6
Thursday, April 28 VENUE EST LOCAL TIME NETWORK
West Coast vs. Melbourne Patersons Stadium 8:40pm 6:40pm TEN
Friday, April 29
Sydney vs. Carlton SCG 7:40pm 7:40pm SEVEN
Saturday, April 30
North Melbourne vs. Port Adelaide Etihad Stadium 2:10pm 2:10pm FOX
Richmond vs. Brisbane MCG 7:10pm 7:10pm FOX
Adelaide vs. St Kilda AAMI Stadium 7:40pm 7:10pm TEN
Sunday, May 1
Essendon vs. Gold Coast Etihad Stadium 1:10pm 1:10pm FOX
Collingwood vs. Western Bulldogs MCG 4:40pm 4:40pm FOX
Byes: Fremantle, Geelong, Hawthorn
Round 7
Friday, May 6 VENUE EST LOCAL TIME NETWORK
Port Adelaide vs. Hawthorn AAMI Stadium 8:40pm 8:10pm SEVEN
Saturday, May 7
Western Bulldogs vs. Sydney Manuka Oval 1:10pm 1:10pm FOX
Geelong vs. North Melbourne Skilled Stadium 2:10pm 2:10pm TEN
Richmond vs. Fremantle MCG 4:10pm 4:10pm FOX
Gold Coast vs. Brisbane Gabba 7:10pm 7:10pm FOX
Sunday, May 8
Essendon vs. West Coast Etihad Stadium 1:10pm 1:10pm FOX
Melbourne vs. Adelaide MCG 2:10pm 2:10pm SEVEN
Monday, May 9
St Kilda vs. Carlton Etihad Stadium 7:20pm 7:20pm TEN
Bye: Collingwood
Round 8
Friday, May 13 VENUE EST LOCAL TIME NETWORK
Geelong vs. Collingwood MCG 7:40pm 7:40pm SEVEN
Saturday, May 14
North Melbourne vs. Melbourne Etihad Stadium 2:10pm 2:10pm TEN
Adelaide vs. Gold Coast AAMI Stadium 3:10pm 2:40pm FOX
Brisbane vs. Essendon Gabba 7:10pm 7:10pm TEN
Sydney vs. Port Adelaide SCG 7:10pm 7:10pm FOX
Sunday, May 15
Hawthorn vs. St Kilda MCG 1:10pm 1:10pm FOX
Western Bulldogs vs. Richmond Etihad Stadium 2:10pm 2:10pm SEVEN
West Coast vs. Fremantle Patersons Stadium 4:40pm 2:40pm FOX
Bye: Carlton
Round 9
Friday, May 20 VENUE EST LOCAL TIME NETWORK
Carlton vs. Geelong Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, May 21
St Kilda vs. Melbourne Etihad Stadium 2:10pm 2:10pm TEN
Port Adelaide vs. Fremantle AAMI Stadium 3:10pm 2:40pm FOX
Brisbane vs. North Melbourne Gabba 7:10pm 7:10pm FOX
Richmond vs. Essendon MCG 7:40pm 7:40pm TEN
Sunday, May 22
Collingwood vs. Adelaide Etihad Stadium 1:10pm 1:10pm FOX
Sydney vs. Hawthorn SCG 2:10pm 2:10pm SEVEN
West Coast vs. Western Bulldogs Patersons Stadium 4:40pm 2:40pm FOX
Bye: Gold Coast
Round 10
Friday, May 27 VENUE EST LOCAL TIME NETWORK
Melbourne vs. Carlton MCG 7:40pm 7:40pm SEVEN
Saturday, May 28
North Melbourne vs. Sydney Etihad Stadium 2:10pm 2:10pm FOX
Fremantle vs. St Kilda Patersons Stadium 3:10pm 1:10pm TEN
Gold Coast vs. Geelong Gold Coast Stadium 7:10pm 7:10pm TEN
Richmond vs. Port Adelaide TIO Stadium 8:40pm 8:10pm FOX
Sunday, May 29
Adelaide vs. Brisbane AAMI Stadium 1:10pm 12:40pm FOX
Collingwood vs. West Coast MCG 2:10pm 2:10pm SEVEN
Western Bulldogs vs. Hawthorn Etihad Stadium 4:40pm 4:40pm FOX
Bye: Essendon
Round 11
Friday, June 3 VENUE EST LOCAL TIME NETWORK
Essendon vs. Melbourne MCG 7:40pm 7:40pm SEVEN
Saturday, June 4
Geelong vs. Western Bulldogs Skilled Stadium 2:10pm 2:10pm TEN
West Coast vs. Gold Coast Patersons Stadium 3:10pm 1:10pm FOX
Brisbane vs. Sydney Gabba 7:10pm 7:10pm FOX
Collingwood vs. St Kilda MCG 7:10pm 7:10pm TEN
Sunday, June 5
Hawthorn vs. Fremantle MCG 1:10pm 1:10pm FOX
North Melbourne vs. Adelaide Etihad Stadium 2:10pm 2:10pm SEVEN
Port Adelaide vs. Carlton AAMI Stadium 4:40pm 4:10pm FOX
Bye: Richmond
Round 12
Friday, June 10 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Western Bulldogs Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, June 11
Adelaide vs. West Coast AAMI Stadium 3:10pm 2:40pm FOX
Gold Coast vs. North Melbourne Gold Coast Stadium 7:10pm 7:10pm FOX
Geelong vs. Hawthorn MCG 7:10pm 7:10pm TEN
Sunday, June 12
Carlton vs. Brisbane Etihad Stadium 1:10pm 1:10pm FOX
Sydney vs. Richmond SCG 2:10pm 2:10pm SEVEN
Fremantle vs. Essendon Patersons Stadium 4:40pm 2:40pm FOX
Monday, June 13
Melbourne vs. Collingwood MCG 2:10pm 2:10pm TEN
Bye: Port Adelaide
Round 13
Friday, June 17 VENUE EST LOCAL TIME NETWORK
Western Bulldogs vs. Adelaide Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, June 18
Hawthorn vs. Gold Coast Aurora Stadium 2:10pm 2:10pm TEN
Essendon vs. North Melbourne Etihad Stadium 2:10pm 2:10pm FOX
Brisbane vs. Richmond Gabba 7:10pm 7:10pm FOX
St Kilda vs. Geelong MCG 7:10pm 7:10pm TEN
Sunday, June 19
Melbourne vs. Fremantle MCG 1:10pm 1:10pm FOX
Carlton vs. Sydney Etihad Stadium 2:10pm 2:10pm SEVEN
West Coast vs. Port Adelaide Patersons Stadium 4:40pm 2:40pm FOX
Bye: Collingwood
Round 14
Friday, June 24 VENUE EST LOCAL TIME NETWORK
Hawthorn vs. Essendon MCG 7:40pm 7:40pm SEVEN
Saturday, June 25
Gold Coast vs. Western Bulldogs Gold Coast Stadium 2:10pm 2:10pm TEN
Richmond vs. Melbourne MCG 2:10pm 2:10pm FOX
Sydney vs. Collingwood ANZ Stadium 7:10pm 7:10pm TEN
Fremantle vs. Brisbane Patersons Stadium 7:40pm 5:40pm FOX
Sunday, June 26
Geelong vs. Adelaide Skilled Stadium 1:10pm 1:10pm FOX
Carlton vs. West Coast Etihad Stadium 2:10pm 2:10pm SEVEN
Port Adelaide vs. North Melbourne AAMI Stadium 4:40pm 4:10pm FOX
Bye: St Kilda
Round 15
Friday, July 1 VENUE EST LOCAL TIME NETWORK
Western Bulldogs vs. Melbourne Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, July 2
Richmond vs. Carlton MCG 2:10pm 2:10pm TEN
Fremantle vs. Gold Coast Patersons Stadium 3:10pm 1:10pm FOX
Essendon vs. Geelong Etihad Stadium 7:10pm 7:10pm TEN
Adelaide vs. Sydney AAMI Stadium 7:40pm 7:10pm FOX
Sunday, July 3
Brisbane vs. Port Adelaide Gabba 1:10pm 1:10pm FOX
Collingwood vs. Hawthorn MCG 2:10pm 2:10pm SEVEN
North Melbourne vs. St Kilda Etihad Stadium 4:40pm 4:40pm FOX
Bye: West Coast
Round 16
Friday, July 8 VENUE EST LOCAL TIME NETWORK
West Coast vs. Geelong Patersons Stadium 8:40pm 6:40pm SEVEN
Saturday, July 9
Hawthorn vs. Brisbane Aurora Stadium 2:10pm 2:10pm FOX
Gold Coast vs. Sydney Gold Coast Stadium 7:10pm 7:10pm FOX
Essendon vs. Richmond MCG 7:10pm 7:10pm TEN
Sunday, July 10
Collingwood vs. North Melbourne MCG 1:10pm 1:10pm FOX
Port Adelaide vs. St Kilda AAMI Stadium 3:10pm 2:40pm SEVEN
Western Bulldogs vs. Carlton Etihad Stadium 4:40pm 4:40pm FOX
Byes: Adelaide, Fremantle, Melbourne
Round 17
Friday, July 15 VENUE EST LOCAL TIME NETWORK
Adelaide vs. Essendon AAMI Stadium 8:40pm 8:10pm SEVEN
Saturday, July 16
Richmond vs. Gold Coast Cazaly's Stadium 2:10pm 2:10pm FOX
Carlton vs. Collingwood MCG 2:10pm 2:10pm TEN
St Kilda vs. West Coast Etihad Stadium 7:10pm 7:10pm FOX
Melbourne vs. Port Adelaide TIO Stadium 8:40pm 8:10pm TEN
Sunday, July 17
Sydney vs. Fremantle SCG 1:10pm 1:10pm FOX
Brisbane vs. Geelong Gabba 2:10pm 2:10pm SEVEN
North Melbourne vs. Western Bulldogs Etihad Stadium 4:40pm 4:40pm FOX
Bye: Hawthorn
Round 18
Friday, July 22 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Adelaide Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, July 23
North Melbourne vs. Brisbane Etihad Stadium 2:10pm 2:10pm TEN
Sydney vs. Western Bulldogs SCG 2:10pm 2:10pm FOX
Gold Coast vs. Collingwood Gold Coast Stadium 7:10pm 7:10pm FOX
Essendon vs. Carlton MCG 7:10pm 7:10pm TEN
Sunday, July 24
Geelong vs. Richmond Etihad Stadium 1:10pm 1:10pm FOX
Melbourne vs. Hawthorn MCG 2:10pm 2:10pm SEVEN
Fremantle vs. West Coast Patersons Stadium 4:40pm 2:40pm FOX
Bye: Port Adelaide
Round 19
Friday, July 29 VENUE EST LOCAL TIME NETWORK
North Melbourne vs. Carlton Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, July 30
Western Bulldogs vs. West Coast Etihad Stadium 2:10pm 2:10pm TEN
Geelong vs. Melbourne Skilled Stadium 2:10pm 2:10pm FOX
Gold Coast vs. St Kilda Gold Coast Stadium 7:10pm 7:10pm FOX
Fremantle vs. Hawthorn Patersons Stadium 7:40pm 5:40pm TEN
Sunday, July 31
Collingwood vs. Essendon MCG 2:10pm 2:10pm SEVEN
Adelaide vs. Port Adelaide AAMI Stadium 4:40pm 4:10pm FOX
Byes: Brisbane, Richmond, Sydney
Round 20
Friday, August 5 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Fremantle Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, August 6
Carlton vs. Melbourne MCG 2:10pm 2:10pm TEN
Geelong vs. Gold Coast Skilled Stadium 2:10pm 2:10pm FOX
Essendon vs. Sydney Etihad Stadium 7:10pm 7:10pm FOX
Port Adelaide vs. Collingwood AAMI Stadium 7:40pm 7:10pm TEN
Sunday, August 7
Brisbane vs. Adelaide Gabba 1:10pm 1:10pm FOX
Hawthorn vs. North Melbourne Aurora Stadium 2:10pm 2:10pm SEVEN
West Coast vs. Richmond Patersons Stadium 4:40pm 2:40pm FOX
Bye: Western Bulldogs
Round 21
Friday, August 12 VENUE EST LOCAL TIME NETWORK
St Kilda vs. Collingwood Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, August 13
Hawthorn vs. Port Adelaide MCG 2:10pm 2:10pm TEN
Fremantle vs. Carlton Patersons Stadium 3:10pm 1:10pm FOX
Western Bulldogs vs. Essendon Etihad Stadium 7:10pm 7:10pm TEN
Brisbane vs. Gold Coast Gabba 7:10pm 7:10pm FOX
Sunday, August 14
Melbourne vs. West Coast Etihad Stadium 1:10pm 1:10pm FOX
Richmond vs. Sydney MCG 2:10pm 2:10pm SEVEN
Adelaide vs. Geelong AAMI Stadium 4:40pm 4:10pm FOX
Bye: North Melbourne
Round 22
Friday, August 19 VENUE EST LOCAL TIME NETWORK
Carlton vs. Hawthorn Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, August 20
Gold Coast vs. Adelaide Gold Coast Stadium 2:10pm 2:10pm FOX
West Coast vs. Essendon Patersons Stadium 3:10pm 1:10pm TEN
North Melbourne vs. Fremantle Etihad Stadium 7:10pm 7:10pm FOX
Collingwood vs. Brisbane MCG 7:10pm 7:10pm TEN
Sunday, August 21
Sydney vs. St Kilda ANZ Stadium 1:10pm 1:10pm FOX
Port Adelaide vs. Western Bulldogs AAMI Stadium 3:10pm 2:40pm SEVEN
Melbourne vs. Richmond MCG 4:40pm 4:40pm FOX
Bye: Geelong
Round 23
Friday, August 26 VENUE EST LOCAL TIME NETWORK
Fremantle vs. Collingwood Patersons Stadium 8:40pm 6:40pm SEVEN
Saturday, August 27
Hawthorn vs. Western Bulldogs MCG 2:10pm 2:10pm TEN
Geelong vs. Sydney Skilled Stadium 2:10pm 2:10pm FOX
St Kilda vs. North Melbourne Etihad Stadium 7:10pm 7:10pm TEN
Brisbane vs. West Coast Gabba 7:10pm 7:10pm FOX
Sunday, August 28
Adelaide vs. Richmond AAMI Stadium 1:10pm 12:40pm FOX
Melbourne vs. Gold Coast MCG 2:10pm 2:10pm SEVEN
Essendon vs. Port Adelaide Etihad Stadium 4:40pm 4:40pm FOX
Bye: Carlton
Round 24
Friday, September 2 - Sunday, September 4 VENUE EST LOCAL TIME NETWORK
Carlton vs. St Kilda MCG TBC TBC TBC
Port Adelaide vs. Melbourne AAMI Stadium TBC TBC TBC
Western Bulldogs vs. Fremantle Etihad Stadium TBC TBC TBC
Sydney vs. Brisbane SCG TBC TBC TBC
West Coast vs. Adelaide Patersons Stadium TBC TBC TBC
Collingwood vs. Geelong MCG TBC TBC TBC
Richmond vs. North Melbourne Etihad Stadium TBC TBC TBC
Gold Coast vs. Hawthorn Gold Coast Stadium TBC TBC TBC
Bye: Essendon
