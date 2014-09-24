#!/usr/bin/perl -w

my @vars;
my $debug = 0;
my @files;

foreach $arg (@ARGV) {
	if ($arg eq "-d") {
		print "Debug mode is on\n";
		$debug = 1;
		next;
	} else {
		push @files, $arg; 
	} 
}

foreach $file (@files) {

	open F, "<$file" or die "$0: cannot open $file: $!";

	while ($line = <F>) {
	
		if ($line =~ /^#!/ && $. == 1) {		
			print "#!/usr/bin/perl -w\n";
	
	#===blank lines===
		} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {	
			print $line;

	#===variables===
		#strings < v1
		#} elsif ($line =~ /^\s*(\w+)\s*=\s*(\w+)\s*$/) {
		#	print "\$$1 = $2;";
		#	print " < v1" if $debug;
		#	print "\n";
		#	push @vars, $1;

		#fancy digit operations parser < v3
		} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-]+)\s*$/) {
			$var = $1; 									#get the variable
			@ops = $2 =~ /(\d+|[\*\+\/\-])/g;	#get the digits and operations
			print "\$$var = @ops;";
			print "< v3" if $debug;
			print "\n";
			push @vars, $var;
	
		#strings with variables < v2
		} elsif ($line =~ /^\s*(\w+)\s*=\s*(.*)$/) {
			@v = split /[^\w\+\-\/\*]/, $2; 		#split on not word or operation
			foreach (@v) {
				s/([a-zA-Z]+)/\$$1/;
				push @vars, $& if (/\w+/);
			}
			print "\$$1 = @v;";
			print "< v2" if $debug;
			print "\n";

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
			@v = split / /, $1;
			foreach (@v) {
				if (/\w+/ and grep {/$_/} @vars) {
				$_ = "\$$_";
				}
			}
			print "print @v, \"\\n\";";
			print " <p3" if $debug;
			print "\n";


	#===else comment out things===
		} else {	
			chomp $line;
			print "#$line# <====this line was not converted\n";
		}
	}
	
	if ($debug) {
		print "vars is: @vars\n";
	}
	close F;
}

#	} elsif ($line =~ /^\s(.*)\s*$/)
