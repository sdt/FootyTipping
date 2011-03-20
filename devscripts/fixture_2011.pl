#!/usr/bin/env perl

use Modern::Perl;

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

            say STDERR "Round $round: '$home_team' vs '$away_team' @ '$venue' $day_of_month/$month";
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

            say STDERR "Round $round: '$home_team' vs '$away_team' @ '$venue' $day_of_month/$month";
        }

        when (/^Byes?:/) {
            # nothing
        }

        default {
            die "Unexpected: $_";
        }
    }
}

__DATA__
Round 1
Thursday, March 24 VENUE EDT LOCAL TIME NETWORK
Carlton vs. Richmond MCG 7:10pm 7:10pm TEN
Friday, March 25
Geelong Cats vs. St. Kilda MCG 7:40pm 7:40pm SEVEN
Saturday, March 26
Collingwood vs. Port Adelaide Etihad Stadium 2:10pm 2:10pm FOX
Adelaide Crows vs. Hawthorn AAMI Stadium 8:40pm 7:10pm TEN
Brisbane Lions vs. Fremantle Gabba 8:10pm 7:10pm FOX
Sunday, March 27
Essendon vs. Western Bulldogs Etihad Stadium 1:10pm 1:10pm FOX
Melbourne vs. Sydney Swans MCG 2:10pm 2:10pm SEVEN
West Coast Eagles vs. North Melbourne Patersons Stadium 7:10pm 4:10pm FOX
Bye: Gold Coast Suns
Round 2
Friday, April 1 VENUE EDT LOCAL TIME NETWORK
St. Kilda vs. Richmond MCG 7:40pm 7:40pm SEVEN
Saturday, April 2
North Melbourne vs. Collingwood Etihad Stadium 2:10pm 2:10pm TEN
Port Adelaide vs. West Coast Eagles AAMI Stadium 3:10pm 2:40pm FOX
Gold Coast Suns vs. Carlton Gabba 7:40pm 6:40pm TEN
Fremantle vs. Geelong Cats Patersons Stadium 8:40pm 5:40pm FOX
Sunday, April 3 EST LOCAL TIME
Western Bulldogs vs. Brisbane Lions Etihad Stadium 1:10pm 1:10pm FOX
Sydney Swans vs. Essendon ANZ Stadium 2:10pm 2:10pm SEVEN
Hawthorn vs. Melbourne MCG 4:40pm 4:40pm FOX
Bye: Adelaide Crows
Round 3
Friday, April 8 VENUE EST LOCAL TIME NETWORK
Collingwood vs. Carlton MCG 7:40pm 7:40pm SEVEN
Saturday, April 9
Western Bulldogs vs. Gold Coast Suns Etihad Stadium 2:10pm 2:10pm TEN
Adelaide Crows vs. Fremantle AAMI Stadium 3:10pm 2:40pm FOX
Richmond vs. Hawthorn MCG 7:10pm 7:10pm TEN
West Coast Eagles vs. Sydney Swans Patersons Stadium 7:40pm 5:40pm FOX
Sunday, April 10
Melbourne vs. Brisbane Lions MCG 1:10pm 1:10pm FOX
Geelong Cats vs. Port Adelaide Skilled Stadium 2:10pm 2:10pm SEVEN
St. Kilda vs. Essendon Etihad Stadium 4:40pm 4:40pm FOX
Bye: North Melbourne
Round 4
Friday, April 15 VENUE EST LOCAL TIME NETWORK
Richmond vs. Collingwood MCG 7:40pm 7:40pm SEVEN
Saturday, April 16
Hawthorn vs. West Coast Eagles Aurora Stadium 2:10pm 2:10pm FOX
Carlton vs. Essendon MCG 2:10pm 2:10pm TEN
Sydney Swans vs. Geelong Cats SCG 7:10pm 7:10pm TEN
Port Adelaide vs. Adelaide Crows AAMI Stadium 7:40pm 7:10pm FOX
Sunday, April 17
Gold Coast Suns vs. Melbourne Gabba 2:10pm 2:10pm SEVEN
Fremantle vs. North Melbourne Patersons Stadium 4:40pm 2:40pm FOX
Byes: Brisbane Lions, St. Kilda, Western Bulldogs
Round 5
Thursday, April 21 VENUE EST LOCAL TIME NETWORK
Brisbane Lions vs. St. Kilda Gabba 7:40pm 7:40pm SEVEN
Saturday, April 23
Port Adelaide vs. Gold Coast Suns AAMI Stadium 3:10pm 2:40pm FOX
Carlton vs. Adelaide Crows Etihad Stadium 7:10pm 7:10pm TEN
Sunday, April 24
North Melbourne vs. Richmond Etihad Stadium 4:40pm 4:40pm FOX
Monday, April 25
Essendon vs. Collingwood MCG 2:40pm 2:40pm TEN
Fremantle vs. Western Bulldogs Patersons Stadium 8:40pm 6:40pm FOX
Tuesday, April 26
Hawthorn vs. Geelong Cats MCG 2:40pm 2:40pm SEVEN
Byes: Melbourne, Sydney Swans, West Coast Eagles
Round 6
Thursday, April 28 VENUE EST LOCAL TIME NETWORK
West Coast Eagles vs. Melbourne Patersons Stadium 8:40pm 6:40pm TEN
Friday, April 29
Sydney Swans vs. Carlton SCG 7:40pm 7:40pm SEVEN
Saturday, April 30
North Melbourne vs. Port Adelaide Etihad Stadium 2:10pm 2:10pm FOX
Richmond vs. Brisbane Lions MCG 7:10pm 7:10pm FOX
Adelaide Crows vs. St. Kilda AAMI Stadium 7:40pm 7:10pm TEN
Sunday, May 1
Essendon vs. Gold Coast Suns Etihad Stadium 1:10pm 1:10pm FOX
Collingwood vs. Western Bulldogs MCG 4:40pm 4:40pm FOX
Byes: Fremantle, Geelong Cats, Hawthorn
Round 7
Friday, May 6 VENUE EST LOCAL TIME NETWORK
Port Adelaide vs. Hawthorn AAMI Stadium 8:40pm 8:10pm SEVEN
Saturday, May 7
Western Bulldogs vs. Sydney Swans Manuka Oval 1:10pm 1:10pm FOX
Geelong Cats vs. North Melbourne Skilled Stadium 2:10pm 2:10pm TEN
Richmond vs. Fremantle MCG 4:10pm 4:10pm FOX
Gold Coast Suns vs. Brisbane Lions Gabba 7:10pm 7:10pm FOX
Sunday, May 8
Essendon vs. West Coast Eagles Etihad Stadium 1:10pm 1:10pm FOX
Melbourne vs. Adelaide Crows MCG 2:10pm 2:10pm SEVEN
Monday, May 9
St. Kilda vs. Carlton Etihad Stadium 7:20pm 7:20pm TEN
Bye: Collingwood
Round 8
Friday, May 13 VENUE EST LOCAL TIME NETWORK
Geelong Cats vs. Collingwood MCG 7:40pm 7:40pm SEVEN
Saturday, May 14
North Melbourne vs. Melbourne Etihad Stadium 2:10pm 2:10pm TEN
Adelaide Crows vs. Gold Coast Suns AAMI Stadium 3:10pm 2:40pm FOX
Brisbane Lions vs. Essendon Gabba 7:10pm 7:10pm TEN
Sydney Swans vs. Port Adelaide SCG 7:10pm 7:10pm FOX
Sunday, May 15
Hawthorn vs. St. Kilda MCG 1:10pm 1:10pm FOX
Western Bulldogs vs. Richmond Etihad Stadium 2:10pm 2:10pm SEVEN
West Coast Eagles vs. Fremantle Patersons Stadium 4:40pm 2:40pm FOX
Bye: Carlton
Round 9
Friday, May 20 VENUE EST LOCAL TIME NETWORK
Carlton vs. Geelong Cats Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, May 21
St. Kilda vs. Melbourne Etihad Stadium 2:10pm 2:10pm TEN
Port Adelaide vs. Fremantle AAMI Stadium 3:10pm 2:40pm FOX
Brisbane Lions vs. North Melbourne Gabba 7:10pm 7:10pm FOX
Richmond vs. Essendon MCG 7:40pm 7:40pm TEN
Sunday, May 22
Collingwood vs. Adelaide Crows Etihad Stadium 1:10pm 1:10pm FOX
Sydney Swans vs. Hawthorn SCG 2:10pm 2:10pm SEVEN
West Coast Eagles vs. Western Bulldogs Patersons Stadium 4:40pm 2:40pm FOX
Bye: Gold Coast Suns
Round 10
Friday, May 27 VENUE EST LOCAL TIME NETWORK
Melbourne vs. Carlton MCG 7:40pm 7:40pm SEVEN
Saturday, May 28
North Melbourne vs. Sydney Swans Etihad Stadium 2:10pm 2:10pm FOX
Fremantle vs. St. Kilda Patersons Stadium 3:10pm 1:10pm TEN
Gold Coast Suns vs. Geelong Cats Gold Coast Stadium 7:10pm 7:10pm TEN
Richmond vs. Port Adelaide TIO Stadium 8:40pm 8:10pm FOX
Sunday, May 29
Adelaide Crows vs. Brisbane Lions AAMI Stadium 1:10pm 12:40pm FOX
Collingwood vs. West Coast Eagles MCG 2:10pm 2:10pm SEVEN
Western Bulldogs vs. Hawthorn Etihad Stadium 4:40pm 4:40pm FOX
Bye: Essendon
Round 11
Friday, June 3 VENUE EST LOCAL TIME NETWORK
Essendon vs. Melbourne MCG 7:40pm 7:40pm SEVEN
Saturday, June 4
Geelong Cats vs. Western Bulldogs Skilled Stadium 2:10pm 2:10pm TEN
West Coast Eagles vs. Gold Coast Suns Patersons Stadium 3:10pm 1:10pm FOX
Brisbane Lions vs. Sydney Swans Gabba 7:10pm 7:10pm FOX
Collingwood vs. St. Kilda MCG 7:10pm 7:10pm TEN
Sunday, June 5
Hawthorn vs. Fremantle MCG 1:10pm 1:10pm FOX
North Melbourne vs. Adelaide Crows Etihad Stadium 2:10pm 2:10pm SEVEN
Port Adelaide vs. Carlton AAMI Stadium 4:40pm 4:10pm FOX
Bye: Richmond
Round 12
Friday, June 10 VENUE EST LOCAL TIME NETWORK
St. Kilda vs. Western Bulldogs Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, June 11
Adelaide Crows vs. West Coast Eagles AAMI Stadium 3:10pm 2:40pm FOX
Gold Coast Suns vs. North Melbourne Gold Coast Stadium 7:10pm 7:10pm FOX
Geelong Cats vs. Hawthorn MCG 7:10pm 7:10pm TEN
Sunday, June 12
Carlton vs. Brisbane Lions Etihad Stadium 1:10pm 1:10pm FOX
Sydney Swans vs. Richmond SCG 2:10pm 2:10pm SEVEN
Fremantle vs. Essendon Patersons Stadium 4:40pm 2:40pm FOX
Monday, June 13
Melbourne vs. Collingwood MCG 2:10pm 2:10pm TEN
Bye: Port Adelaide
Round 13
Friday, June 17 VENUE EST LOCAL TIME NETWORK
Western Bulldogs vs. Adelaide Crows Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, June 18
Hawthorn vs. Gold Coast Suns Aurora Stadium 2:10pm 2:10pm TEN
Essendon vs. North Melbourne Etihad Stadium 2:10pm 2:10pm FOX
Brisbane Lions vs. Richmond Gabba 7:10pm 7:10pm FOX
St. Kilda vs. Geelong Cats MCG 7:10pm 7:10pm TEN
Sunday, June 19
Melbourne vs. Fremantle MCG 1:10pm 1:10pm FOX
Carlton vs. Sydney Swans Etihad Stadium 2:10pm 2:10pm SEVEN
West Coast Eagles vs. Port Adelaide Patersons Stadium 4:40pm 2:40pm FOX
Bye: Collingwood
Round 14
Friday, June 24 VENUE EST LOCAL TIME NETWORK
Hawthorn vs. Essendon MCG 7:40pm 7:40pm SEVEN
Saturday, June 25
Gold Coast Suns vs. Western Bulldogs Gold Coast Stadium 2:10pm 2:10pm TEN
Richmond vs. Melbourne MCG 2:10pm 2:10pm FOX
Sydney Swans vs. Collingwood ANZ Stadium 7:10pm 7:10pm TEN
Fremantle vs. Brisbane Lions Patersons Stadium 7:40pm 5:40pm FOX
Sunday, June 26
Geelong Cats vs. Adelaide Crows Skilled Stadium 1:10pm 1:10pm FOX
Carlton vs. West Coast Eagles Etihad Stadium 2:10pm 2:10pm SEVEN
Port Adelaide vs. North Melbourne AAMI Stadium 4:40pm 4:10pm FOX
Bye: St. Kilda
Round 15
Friday, July 1 VENUE EST LOCAL TIME NETWORK
Western Bulldogs vs. Melbourne Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, July 2
Richmond vs. Carlton MCG 2:10pm 2:10pm TEN
Fremantle vs. Gold Coast Suns Patersons Stadium 3:10pm 1:10pm FOX
Essendon vs. Geelong Cats Etihad Stadium 7:10pm 7:10pm TEN
Adelaide Crows vs. Sydney Swans AAMI Stadium 7:40pm 7:10pm FOX
Sunday, July 3
Brisbane Lions vs. Port Adelaide Gabba 1:10pm 1:10pm FOX
Collingwood vs. Hawthorn MCG 2:10pm 2:10pm SEVEN
North Melbourne vs. St. Kilda Etihad Stadium 4:40pm 4:40pm FOX
Bye: West Coast Eagles
Round 16
Friday, July 8 VENUE EST LOCAL TIME NETWORK
West Coast Eagles vs. Geelong Cats Patersons Stadium 8:40pm 6:40pm SEVEN
Saturday, July 9
Hawthorn vs. Brisbane Lions Aurora Stadium 2:10pm 2:10pm FOX
Gold Coast Suns vs. Sydney Swans Gold Coast Stadium 7:10pm 7:10pm FOX
Essendon vs. Richmond MCG 7:10pm 7:10pm TEN
Sunday, July 10
Collingwood vs. North Melbourne MCG 1:10pm 1:10pm FOX
Port Adelaide vs. St. Kilda AAMI Stadium 3:10pm 2:40pm SEVEN
Western Bulldogs vs. Carlton Etihad Stadium 4:40pm 4:40pm FOX
Byes: Adelaide Crows, Fremantle, Melbourne
Round 17
Friday, July 15 VENUE EST LOCAL TIME NETWORK
Adelaide Crows vs. Essendon AAMI Stadium 8:40pm 8:10pm SEVEN
Saturday, July 16
Richmond vs. Gold Coast Suns Cazaly's Stadium 2:10pm 2:10pm FOX
Carlton vs. Collingwood MCG 2:10pm 2:10pm TEN
St. Kilda vs. West Coast Eagles Etihad Stadium 7:10pm 7:10pm FOX
Melbourne vs. Port Adelaide TIO Stadium 8:40pm 8:10pm TEN
Sunday, July 17
Sydney Swans vs. Fremantle SCG 1:10pm 1:10pm FOX
Brisbane Lions vs. Geelong Cats Gabba 2:10pm 2:10pm SEVEN
North Melbourne vs. Western Bulldogs Etihad Stadium 4:40pm 4:40pm FOX
Bye: Hawthorn
Round 18
Friday, July 22 VENUE EST LOCAL TIME NETWORK
St. Kilda vs. Adelaide Crows Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, July 23
North Melbourne vs. Brisbane Lions Etihad Stadium 2:10pm 2:10pm TEN
Sydney Swans vs. Western Bulldogs SCG 2:10pm 2:10pm FOX
Gold Coast Suns vs. Collingwood Gold Coast Stadium 7:10pm 7:10pm FOX
Essendon vs. Carlton MCG 7:10pm 7:10pm TEN
Sunday, July 24
Geelong Cats vs. Richmond Etihad Stadium 1:10pm 1:10pm FOX
Melbourne vs. Hawthorn MCG 2:10pm 2:10pm SEVEN
Fremantle vs. West Coast Eagles Patersons Stadium 4:40pm 2:40pm FOX
Bye: Port Adelaide
Round 19
Friday, July 29 VENUE EST LOCAL TIME NETWORK
North Melbourne vs. Carlton Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, July 30
Western Bulldogs vs. West Coast Eagles Etihad Stadium 2:10pm 2:10pm TEN
Geelong Cats vs. Melbourne Skilled Stadium 2:10pm 2:10pm FOX
Gold Coast Suns vs. St. Kilda Gold Coast Stadium 7:10pm 7:10pm FOX
Fremantle vs. Hawthorn Patersons Stadium 7:40pm 5:40pm TEN
Sunday, July 31
Collingwood vs. Essendon MCG 2:10pm 2:10pm SEVEN
Adelaide Crows vs. Port Adelaide AAMI Stadium 4:40pm 4:10pm FOX
Byes: Brisbane Lions, Richmond, Sydney Swans
Round 20
Friday, August 5 VENUE EST LOCAL TIME NETWORK
St. Kilda vs. Fremantle Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, August 6
Carlton vs. Melbourne MCG 2:10pm 2:10pm TEN
Geelong Cats vs. Gold Coast Suns Skilled Stadium 2:10pm 2:10pm FOX
Essendon vs. Sydney Swans Etihad Stadium 7:10pm 7:10pm FOX
Port Adelaide vs. Collingwood AAMI Stadium 7:40pm 7:10pm TEN
Sunday, August 7
Brisbane Lions vs. Adelaide Crows Gabba 1:10pm 1:10pm FOX
Hawthorn vs. North Melbourne Aurora Stadium 2:10pm 2:10pm SEVEN
West Coast Eagles vs. Richmond Patersons Stadium 4:40pm 2:40pm FOX
Bye: Western Bulldogs
Round 21
Friday, August 12 VENUE EST LOCAL TIME NETWORK
St. Kilda vs. Collingwood Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, August 13
Hawthorn vs. Port Adelaide MCG 2:10pm 2:10pm TEN
Fremantle vs. Carlton Patersons Stadium 3:10pm 1:10pm FOX
Western Bulldogs vs. Essendon Etihad Stadium 7:10pm 7:10pm TEN
Brisbane Lions vs. Gold Coast Suns Gabba 7:10pm 7:10pm FOX
Sunday, August 14
Melbourne vs. West Coast Eagles Etihad Stadium 1:10pm 1:10pm FOX
Richmond vs. Sydney Swans MCG 2:10pm 2:10pm SEVEN
Adelaide Crows vs. Geelong Cats AAMI Stadium 4:40pm 4:10pm FOX
Bye: North Melbourne
Round 22
Friday, August 19 VENUE EST LOCAL TIME NETWORK
Carlton vs. Hawthorn Etihad Stadium 7:40pm 7:40pm SEVEN
Saturday, August 20
Gold Coast Suns vs. Adelaide Crows Gold Coast Stadium 2:10pm 2:10pm FOX
West Coast Eagles vs. Essendon Patersons Stadium 3:10pm 1:10pm TEN
North Melbourne vs. Fremantle Etihad Stadium 7:10pm 7:10pm FOX
Collingwood vs. Brisbane Lions MCG 7:10pm 7:10pm TEN
Sunday, August 21
Sydney Swans vs. St. Kilda ANZ Stadium 1:10pm 1:10pm FOX
Port Adelaide vs. Western Bulldogs AAMI Stadium 3:10pm 2:40pm SEVEN
Melbourne vs. Richmond MCG 4:40pm 4:40pm FOX
Bye: Geelong Cats
Round 23
Friday, August 26 VENUE EST LOCAL TIME NETWORK
Fremantle vs. Collingwood Patersons Stadium 8:40pm 6:40pm SEVEN
Saturday, August 27
Hawthorn vs. Western Bulldogs MCG 2:10pm 2:10pm TEN
Geelong Cats vs. Sydney Swans Skilled Stadium 2:10pm 2:10pm FOX
St. Kilda vs. North Melbourne Etihad Stadium 7:10pm 7:10pm TEN
Brisbane Lions vs. West Coast Eagles Gabba 7:10pm 7:10pm FOX
Sunday, August 28
Adelaide Crows vs. Richmond AAMI Stadium 1:10pm 12:40pm FOX
Melbourne vs. Gold Coast Suns MCG 2:10pm 2:10pm SEVEN
Essendon vs. Port Adelaide Etihad Stadium 4:40pm 4:40pm FOX
Bye: Carlton
Round 24
Friday, September 2 - Sunday, September 4 VENUE EST LOCAL TIME NETWORK
Carlton vs. St. Kilda MCG TBC TBC TBC
Port Adelaide vs. Melbourne AAMI Stadium TBC TBC TBC
Western Bulldogs vs. Fremantle Etihad Stadium TBC TBC TBC
Sydney Swans vs. Brisbane Lions SCG TBC TBC TBC
West Coast Eagles vs. Adelaide Crows Patersons Stadium TBC TBC TBC
Collingwood vs. Geelong Cats MCG TBC TBC TBC
Richmond vs. North Melbourne Etihad Stadium TBC TBC TBC
Gold Coast Suns vs. Hawthorn Gold Coast Stadium TBC TBC TBC
Bye: Essendon
