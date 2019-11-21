# subtitleAdjuster
A Perl script to adjust (shift) subtitles 

# Purpose
This a simple perl script used to shift timestamps of movie subtitles.

# Directions
Before running the program, you must have Perl installed on your system.
Perl comes pre-installed on MacOS and Linux Distros
Make sure this program is executable use the command "chmod +x subr.pl"

## example: ./subr.pl -f file_name.srt +1h -2m +6s -100ms
Note: the order of the arguments does not matter. 
      It is however required to specified the + or - next to the shift
      If the filename includes whitespaces, it is recommended to pass
      it to the program using quotation marks " ".

The file with the shifted timestamps will have a _new.srt appended
in its name. 

This code could probably a lot shorter, but I opt for readability ;) 


# Assumptions regarding the input subtitle format
The subtitle format should be of the form: 
N
hh:mm:ss,ms --> hh:mm:ss,ms 
TEXT TEXT 

or 
N
hh:mm:ss.ss_fraction -->hh:mm:ss.ms
TEXT TEXT 

Example: 
2
00:01:30.280 --> 00:01:34.918
<i>In the Bay of Naples, a few kilometers
from Pompeii and Vesuvius,</i>

3
00:01:30,300 --> 00:01:34,900
Hey there
