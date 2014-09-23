#!/usr/bin/perl
# Starting point for COMP2041/9041 assignment 
# http://www.cse.unsw.edu.au/~cs2041/assignments/python2perl
# written by andrewt@cse.unsw.edu.au September 2014

my @vars;
$debug = pop, @ARGV;

while ($line = <>) {
	if ($line =~ /^#!/ && $. == 1) {		
		print "#!/usr/bin/perl -w\n";
	
#===blank lines===
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {	
		print $line;

#===variables===
	#strings < v1
	} elsif ($line =~ /^\s*(\w+)\s*=\s*(\w+)\s*$/) {
		print "\$$1 = $2;";
		print " < v1" if $debug;
		print "\n";
		push @vars, $2;
	
	#strings with variables < v2
	} elsif ($line =~ /^\s*(\w+)\s*=\s*(.*)$/) {
		@v = split / /, $2;
		foreach (@v) {
			$_ =~ s/(\w+)/\$$1/;
		}
		print "\$$1 = @v";
		print "< v2" if $debug;
		print "\n";
		push @vars, $2;

	#fancy digit operations parser < v3
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-]+)\s*$/) {
		$var = $1;
		@operations = $line =~ /\s*(\d+|[\*\+\/\-])/g;
		#print "op is !@operations!\n";
		print "\$$var = @operations;";
		print "< v3" if $debug;
		print "\n";
		push @vars, $2;

	#unfancy < v4
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-]+)\s*$/) {
		print "\$$1 = $2;";
		print " < v4" if $debug;
		print "\n";
		push @vars, $2;


#===printing===
	#general? < p1
	#} elsif ($line =~ /^\s*print\s*"?(.*)"?\s*$/) {
	#	@v = split / /, $1;
	#	print "print \"@v, \"\\n\";";
	#	print " <p1" if $debug;
	#	print "\n";	
	
	#with quotes < p2
	} elsif ($line =~ /^\s*print\s*"(.*)"\s*$/) {		
		print 'print \"$1\\n\";';
		print " <p2";
		print "\n";
	
	#without quotes <p3
	} elsif ($line =~ /^\s*print\s*(.*)\s*$/) {		
		print "print \$$1\,\ \"\\n\";";
		print " <p3" if $debug;
		print "\n";


#===else comment out things===
	} else {	
		chomp $line;
		print "#$line# <====this line was not converted\n";
	}
}

#	} elsif ($line =~ /^\s(.*)\s*$/)
