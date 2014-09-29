#!/usr/bin/perl -w

my $debug = 0;
my $print = 0;
my @files;
my @vars;

foreach $arg (@ARGV) {			#set flags
	if ($arg eq "-d") {
		print "Debug mode is on\n";
		$debug = 1;
	} elsif ($arg eq "-p") {
		$print = 1;
	} else {
		push @files, $arg; 
	} 
}

sub makeLine
{

	my $final = "";
	my ($line) = (@_);

	print "===In makeLine:=== debug is $debug\nline is $line:\n\n" if $debug;
	
	if ($line =~ /^#!/) {
		print "#!/usr/bin/perl -w\n";

#===blank lines===
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {	
		print "$line\n";

#===variables===
	#strings < v1
	#} elsif ($line =~ /^\s*(\w+)\s*=\s*(\w+)\s*$/) {
	#	print "\$$1 = $2;";
	#	print " < v1" if $debug;
	#	print "\n";
	#	push @vars, $1;

	#fancy digit operations parser < v1
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-]+)\s*$/) {
		$var = $1; 									#get the variable
		@ops = $2 =~ /(\d+|[\*\+\/\-])/g;	#get the digits and operations
		$final .= "\$$var = @ops;";
		$final .= " <v1" if $debug or $print;
		$final .= "\n";
		push @vars, $var;

	#strings with variables < v2
	} elsif ($line =~ /^\s*(\w+)\s*=\s*(.*)$/) {
		@v = split /[^\w\+\-\/\*]/, $2; 		#split on not word or operation
		foreach (@v) {
			s/([a-zA-Z]+)/\$$1/;
			push @vars, $& if (/\w+/);
		}
		$final .= "\$$1 = @v;";
		$final .= " <v2" if $debug or $print;
		$final .= "\n";

	#unfancy < v3
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-]+)\s*$/) {
		$final .= "\$$1 = $2;";
		$final .= " <v3" if $debug or $print;
		$final .= "\n";
		push @vars, $2;

#===if statements====

	#single line if statement
	} elsif ($line =~ /^(\s*)\bif\b\s+(.*?)\s*:\s*(.*)$/) {
		$final .= "if ($2) \{\n\t$1$3;\n$1}";
		$final .= " <v4" if $debug or $print;
		$final .= "\n";

	#how to do multiline...?
	#thoughts, handle if statements in a different run through file....

#===printing===
	#general? < p1
	#} elsif ($line =~ /^\s*print\s*"?(.*)"?\s*$/) {
	#	@v = split / /, $1;
	#	print "print \"@v, \"\\n\";";
	#	print " <p1" if $debug;
	#	print "\n";	

	#with quotes < p2
	} elsif ($line =~ /^\s*\bprint\b\s*"(.*)"\s*$/) {		
		$final .= "print \"$1\\n\";";
		$final .= " <p2" if $debug or $print;
		$final .= "\n";

	#without quotes <p3
	} elsif ($line =~ /^\s*\bprint\b\s*(.*)\s*$/) {		
		@v = split / /, $1;
		foreach (@v) {
			if (/\w+/ and grep {/$_/} @vars) {
			$_ = "\$$_";
			}
		}
		$final .= "print @v, \"\\n\";";
		$final .= " <p3" if $debug or $print;
		$final .= "\n";


#===else comment out things===
	} else {	
		$final .= "#$line# <====this line was not converted\n";
	}
	

	print "vars is: @vars\n" if $debug or $print;
	print "===End makeline===\n" if $debug;
	
	close F;
	
	return $final;
}


sub makeBlock			#super cool recursion I think....
{
	my $in = 1;
	my (@block) = (@_);
	$block[0] =~ /^(\s*).*$/; 								#get indent
	$indent = $1;
	print "made it to block\nIndent is !$indent!\n" if $debug;
	foreach $line (@block) {
		chomp $line;
		print "in make block: $line\n" if $debug;
		if ($line =~ /^$indent(\S)(.*)$/ and $in) {	#print lines in the current indent normally
			print "check_100\n" if $debug;
			print makeLine($line);
		} elsif ($line =~ /^$indent\s+(\S*)$/) {		#if we get to a more indented block, push onto stack
			print "check_200\n" if $debug;
			push @chunk, $line;								#until end of that block and then make that block
			$in = 0;
		} elsif ($line =~ /^$indent(\S)(.*)$/) {		#once we get to the end of that block, make it
			print "check_300\n" if $debug;
			makeBlock(@chunk);						#then keep going
			print makeLine($line);
			$in = 1;
		} else {
			print "$line\n";
		}
	}
}


foreach $file (@files)
{

	open F, "<$file" or die "$0: cannot open $file: $!";
	@f = <F>;

	if ($debug) {
		print "File to be converted\n.......\n";
		print "$_" foreach (@f);
		print ".......\n\n";
	}

	makeBlock(@f);
	
}

#this is a change





