#!/usr/bin/perl
# Starting point for COMP2041/9041 assignment 
# http://www.cse.unsw.edu.au/~cs2041/assignments/python2perl
# written by andrewt@cse.unsw.edu.au September 2014

while ($line = <>) {
	if ($line =~ /^#!/ && $. == 1) {		
		print "#!/usr/bin/perl -w\n";
	
#===blank lines===
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {	
		print $line;
	
#===printing===
	} elsif ($line =~ /^\s*print\s*"(.*)"\s*$/) {		
		print "print \"$1\\n\";\n";
		
	} elsif ($line =~ /^\s*print\s*(.*)\s*$/) {		
		print "print \$$1\,\ \"\\n\";\n";

#===variables===
	#strings
	} elsif ($line =~ /^\s*(\w+)\s*=\s*(\w+)\s*$/) {
		print "\$$1 = $2;\n";
	
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/-]+)\s*$/) {
		print "\$$1 = $2;\n";		


#===else comment out things===
	} else {	
		chomp $line;
		print "#$line# <====this line was not converted\n";
	}
}

#	} elsif ($line =~ /^\s(.*)\s*$/)
