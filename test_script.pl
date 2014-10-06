#!/usr/bin/perl -w
# written by andrewt@cse.unsw.edu.au as a COMP2041 lecture example
# Count the number of lines on standard input.


@lines = ();
foreach $line (<STDIN>)
{
    chomp($line);
    push @lines, $line;
    
}
$i = scalar(@lines) - 1;
while ($i   >= 0)
{
    print $lines[$i], "\n";
    $i = $i - 1;
}
