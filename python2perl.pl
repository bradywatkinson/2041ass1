#!/usr/bin/perl
# Starting point for COMP2041/9041 assignment 
# http://www.cse.unsw.edu.au/~cs2041/assignments/python2perl
# written by andrewt@cse.unsw.edu.au September 2014

while ($line = <>) {
	if ($line =~ /^#!/ && $. == 1) {		
		print "#!/usr/bin/perl -w\n";
		
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {		
		print $line;
		
	} elsif ($line =~ /^\s*print\s*"(.*)"\s*$/) {		
		print "print \"$1\\n\";\n";
		
	} elsif ($line =~ /^\s*print\s*(.*)\s*$/) {		
		print "print \$$1\,\ \"\\n\";\n";

	} elsif ($line =~ /^\s*(\w+)\s*=\s*(\w+)\s*$/) {
		print "\$$1 = $2;\n";

	} else {
	
		# Lines we can't translate are turned into comments
		
		print "#$line\n";
	}
}
