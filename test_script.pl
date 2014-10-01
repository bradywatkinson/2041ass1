#!/usr/bin/perl -w
# written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
# Count the number of lines on standard input.



@lines = <STDIN>;
$line_count = scalar(@lines);
printf "%d lines\n" , $line_count;
