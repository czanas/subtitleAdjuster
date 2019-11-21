#!/usr/bin/perl
#perl script
#Author: MZ
#Purpose: this a simple perl script used to shift timestamps
#         of movie subtitles.

#Directions:
#   before running the program, you must have Perl installed on your system.
#   Perl comes pre-installed on MacOS and Linux Distros
#   !!Make sure this program is executable use the command "chmod +x subr.pl"
#
#example: ./subr.pl -f file_name.srt +1h -2m +6s -100ms
#Note: the order of the arguments does not matter. 
#      It is however required to specified the + or - next to the shift
#      If the filename includes whitespaces, it is recommended to pass
#      it to the program using quotation marks " ".
#
#The file with the shifted timestamps will have a _new.srt appended
#in its name. 
#
#This code could probably a lot shorter, but I opt for readability ;) 
#
#
#Assumption regarding the input subtitle format
#it should be of the form: 
#N
#hh:mm:ss,ms --> hh:mm:ss,ms 
#TEXT TEXT 
#
#or 
#N
#hh:mm:ss.ss_fraction -->hh:mm:ss.ms
#TEXT TEXT 
#
#Example: 
#2
#00:01:30.280 --> 00:01:34.918
#<i>In the Bay of Naples, a few kilometers
#from Pompeii and Vesuvius,</i>
#
#3
#00:01:30,300 --> 00:01:34,900
#Hey there


#use strict;
#use warnings;
#use File::Copy;


#needed sub functions to be used
#convert timestamp to milliseconds
#format must be hh:mm:ss,ms
sub str_to_ms{
    
    $str = $_[0];
    $t = 0; 
    if($str =~ /(\d{0,}\.{0,}\d{0,})\:(\d{0,}\.{0,}\d{0,})\:(\d{0,})\,(\d{0,}\.{0,}\d{0,})/)
    {
         $t = $1*60*60*1000+$2*60*1000+$3*1000+$4;
    }else {
        if ($str =~ /(\d{0,}\.{0,}\d{0,})\:(\d{0,}\.{0,}\d{0,})\:(\d{0,}\.{0,}\d{0,})/){
            $t = $1*60*60*1000+$2*60*1000+$3*1000;
        }else{
    
            print "\nSubtitle format error\nTime stamp should be in the format\nhh:mm:ss,ms \nOR\nhh:mm:ss._fractSec\nWe found this: \"".$_[0]."\"\n\n";
            exit; 
        }
    }
    
    return $t;
}

#converts milliseconds integers to time stamp
#format returned is hh:mm:ss,ms
sub ms_to_str{
    $val = $_[0];
    $hours = int($val/(60*60*1000));
    $mins = int(($val-$hours*60*60*1000)/(60*1000));
    $secs = int(($val-$hours*60*60*1000-$mins*60*1000)/(1000));
    $ms   = int(($val-$hours*60*60*1000-$mins*60*1000)-$secs*1000);
    
    return sprintf("%02d:%02d:%02d,%d", $hours,$mins,$secs,$ms);     
}

#shift a time stamp by a certain number of milliseconds
sub shift_time{
    
    $time = ms_to_str(str_to_ms($_[0])+$_[1]);    
    return $time;
}


#print @ARGV;
#print "\n";
$args = join " ", @ARGV; 

#start parsing the input to get the desired parameters
$shift_ms = $args =~ /([\+|\-]{1}\s*\d+)\s*ms\b/?$1:0;  
$shift_s = $args =~ /([\+\-]{1}\s*\d+)\s*s\b/?$1:0; 
$shift_m = $args =~ /([\+\-]{1}\s*\d+)\s*m\b/?$1:0; 
$shift_h = $args =~ /([\+\-]{1}\s*\d+)\s*h\b/?$1:0; 
$f_name = $args =~ /\-f\s*(.*\.srt)\b/?$1:"";

#print "\n";
#print $shift_ms."ms ".$shift_s."s ".$shift_h."h ".$shift_m."m ".$f_name;

if ($f_name eq ""){

	print "\nError. Missing arguments (No filename).\n\nUsage Example: ./r.perl -f FILENAME.srt +100ms -2s +1m -1h\n
The above shifts the subtitle in FILENAME.srt by: 
	+100 milliseconds, 
	-2 seconds, 
	+1 minute, and 
	-1 hour\n"; 

}else
{
    print "\n~~~Now Processing~~~\n";
	print "Filename: ".$f_name."\n";
    print "Shift subtitle timestamps by $shift_h hour(s) $shift_m minute(s)";
    print " $shift_s second(s) $shift_ms millisecond(s)\n";
    
	
	#calculate the total shift in milliseconds
	$shift_total = $shift_h*60*60*1000+$shift_m*60*1000+$shift_s*1000+$shift_ms;
    print "Or ".$shift_total." milliseconds\n";
    #print "\n".shift_time("02:11:32,234", $shift_total);
    
    #create new file to work on
    $new_f = $f_name; 
    $new_f =~ s/\.srt/\_new\.srt/g;
    open my $in, '<', $f_name or die "couldn't open file\n";
    open my $out, '>', $new_f or die "couldn't write to new file\n";
    
    while( <$in> ){
        #find the timestamps
        if($_ =~ /([\d:,\.]+)\s+-{2}\>\s+([\d:,\.]+)/ )
        {
            $start = $1; 
            $end = $2; 
            
            $new_start = shift_time($start, $shift_total);
            $new_end = shift_time($end, $shift_total);
            
            $new_str = "$new_start --> $new_end\n";
            print $out $new_str;
            
        }else
        {
            print $out $_; 
        }
        
    }
    close $out;
    
    print "\nNew Filename: $new_f";
	print "\n~~~Done~~~\n";
}
