#!/usr/bin/perl -w

my $debug = 0;
my $print = 0;
my @files;
my @vars;
my @prefix = ('$','@');

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

sub makeFunction
{
	my $func = "";
	my ($line) = (@_);
	
#===range===
	if ($line =~ /range\((.+?), ?(.+?)\)/) {
		$tmp1 = $1;
		$tmp2 = $2;
		@ops1 = $tmp1 =~ /(\d+|[\*\+\/\-\%])/g;
		foreach (@ops1) {
			s/([a-zA-Z]+)/\$$1/;
			push @vars, $& if (/\w+/);
		}
		@ops2 = $tmp2 =~ /(\w+|\d+|[\*\+\/\-\%])/g;
		foreach (@ops2) {
			s/([a-zA-Z]+)/\$$1/;
			push @vars, $& if (/\w+/);
		}
		$func .= "(@ops1..@ops2-1)";
		$func .= "<frange" if $debug or $print;
#===sys.stdout.write====
	}elsif ($line =~ /sys.stdout.write\("?(.*?)"?\)/) {	
		$func .= "print \"".$1."\";";
		$func .= "<fout" if $debug or $print;
#===sys.stdin.readline====
	}elsif ($line =~ /sys.stdin.readlines?\(\)/) {	
		$func .= "<STDIN>";
		$func .= "<fin" if $debug or $print;
#===int====
	}elsif ($line =~ /^\s*int\("?(.*?)"?\)/) {
		if (!makeFunction($1)) {
			$func .= makeFunction($1);
		} else {
			$func .= "$1";
		}
		$func .= "<fint" if $debug or $print;
#===break===		
	}elsif ($line =~ /^break/) {	
		$func .= "last;";
		$func .= "<fbreak" if $debug or $print;		
#===len===		
	}elsif ($line =~ /^\s*len\("?(.*?)"?\)/) {
		$var = "\@".$1;
		$func .= "scalar\($var\)";
		$func .= "<flen" if $debug or $print;		
	
	
	
	
	
	
	}		
	
	
	return $func;
}

sub isArray
{
	my $isArray = 0;
	my ($line) = (@_);

	$isArray = 1 if ($line =~ /sys.stdin.readlines\(\)/);
		
	return $isArray;
}


sub makeLine
{

	my $final = "";
	my ($line) = (@_);

	print "...making line... \n$line\n" if $debug;
	
	if (!$line) {
		return "";
	}
	
	if ($line =~ /^#!/) {
		$final .= "#!/usr/bin/perl -w";

#===blank lines===
	} elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {	
		$final .= "$line";

#===importing things (not needed in perl)===
	} elsif ($line =~ /^import/) {	
		$final .= "";


#===assigning variables===

	#variables with functions <v0
	} elsif ($line =~ /^\s*(\w+)\s*=\s*(.*)\s*$/ and makeFunction($2)) {
		my $var = $prefix[isArray($line)].$1;
		$final .= "$var = ".makeFunction($2).";";
		$final .= " <v0" if $debug or $print;
		#$final .= "\n";
		push @vars, $var;	

	#fancy digit operations parser < v1
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-\%]+)\s*$/) {
		my $var = $prefix[isArray($line)].$1; 									#get the variable
		@ops = $2 =~ /(\d+|[\*\+\/\-\%])/g;	#get the digits and operations
		$final .= "$var = @ops;";
		$final .= " <v1" if $debug or $print;
		#$final .= "\n";
		push @vars, $var;

	#strings with variables < v2
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([^=]*)$/) {
		my $var = $prefix[isArray($line)].$1;
		push @vars, $var;
		@v = split /[^\w\+\-\/\*\%]/, $2; 		#split on not word or operation
		foreach (@v) {
			s/([a-zA-Z]+)/\$$1/;
			push @vars, $& if (/\w+/);
		}
		$final .= "$var = @v;";
		$final .= " <v2" if $debug or $print;
		#$final .= "\n";

	#unfancy < v3
	} elsif ($line =~ /^\s*(\w+)\s*=\s*([\d\ \*\+\/\-\%]+)\s*$/) {
		my $var = $prefix[isArray($line)].$1;
		$final .= "$var = $2;";
		$final .= " <v3" if $debug or $print;
		push @vars, $2;


#===comparison operators===
		
	#operators before comparison < c2
	} elsif ($line =~ /^\s*(.*)\s*(==|>|<|!=|<=|>=)\s*(\w+)\s*$/) {
		@v = split /[^\w\+\-\/\*\%]/, $1;
		@w = split /[^\w\+\-\/\*\%]/, $3;
		foreach (@v) {
			s/([a-zA-Z]+)/\$$1/;
			push @vars, $& if (/\w+/);
		}
		foreach (@w) {
			s/([a-zA-Z]+)/\$$1/;
			push @vars, $& if (/\w+/);
		}
		$final .= "@v $2 @w";
		$final .= " <c2" if $debug or $print;
		

	#unfancy < c1
	} elsif ($line =~ /^\s*(\w+)\s*(==|>|<|!=|<=|>=)\s*(\w+)\s*$/) {
		$final .= "\$" if (grep {/$1/} @vars);
		$final .= "$1 $2 ";
		$final .= "\$" if (grep {/$3/} @vars);
		$final .= $3;
		$final .= " <c1" if $debug or $print;

#===foreach statements===
	
	} elsif ($line =~ /^\s*for\s+(\w+)\s+in\s(.*?)\s*:\s*$/) {
		$var = $prefix[isArray($line)].$1;
		push @vars, $var;
		$final .= "foreach \$$1 ". makeFunction($2);
		$final .= " <fe1" if $debug or $print;

#===if and while statements====

	#						|if/while/elif|   |test|		  |do|
	} elsif ($line =~ /^\s*(\w+)\s+(.*?)\s*:\s*(.*)$/) {
		if ($3) { 	#single line if or while statement
			$final .= "$1 (". makeLine($2).") \{\n\t".makeLine($3)."\n}";
			$final .= " <v4" if $debug or $print;
		} else { 	#multi line if or while statement
			$final .= "$1 (". makeLine($2).")";
			$final .= " <v4" if $debug or $print;			
		}

#===if and while statements====

	} elsif ($line =~ /^\s*else:$/) {
		$final .= "else";

#===split line up====
	} elsif ($line =~ /(.*[^\\]);(.*)/) {	
		$final .= "|s|" if $debug or $print;
		$final .= makeLine($1) . "\n\t" . makeLine($2);
		$final .= "|s|" if $debug or $print;

#===printing===
	#general? < p1
	#} elsif ($line =~ /^\s*print\s*"?(.*)"?\s*$/) {
	#	@v = split / /, $1;
	#	print "print \"@v, \"\\n\";";
	#	print " <p1" if $debug;
	#	print "\n";	

	#printf <p0
	} elsif ($line =~ /^\s*print\s+"(.*?)"\s*%\s*(.*)$/) {
		my $str = $1;		
		@w = split / /, $2;
		foreach (@w) {
			if (/\w+/ and "\$$_" ~~ @vars) {
				$_ = "\$$_";
			}
		}
		$final .= "printf \"$str\\n\" , ".(join ',',@w).";";
		$final .= " <p0" if $debug or $print;

	#single newline <p1
	} elsif ($line =~ /^\s*print\s*$/) {		
		$final .= "print "."\"\\n\";";
		$final .= " <p1" if $debug or $print;

	#with quotes < p2
	} elsif ($line =~ /^\s*print\s*"(.*)"\s*$/) {		
		$final .= "print \"".$1."\\n\";";
		$final .= " <p2" if $debug or $print;

	#without quotes <p3
	} elsif ($line =~ /^\s*print\s*(.*)\s*$/) {		
		@v = split / /, $1;
		foreach (@v) {
			if (/\w+/ and "\$$_" ~~ @vars) {
				$_ = "\$$_";
			} elsif (/\w+/ and "\@$_" ~~ @vars) {
				$_ = "\@$_";
			}
		}
		$final .= "print @v, \"\\n\";";
		$final .= " <p3" if $debug or $print;


#check if it is a function....
	} elsif (makeFunction($line)) {	
		$final .= makeFunction($line);

#===else comment out things===
	} else {	
		$final .= "#$line# <====this line was not converted";
	}
	
	$final =~ s/elif/elsif/;
	print "vars is: @vars\n" if $debug or $print;
	#print "===End makeline===\n" if $debug;
	
	close F;
	
	return $final;
}


sub printBlock
{
	print "printing block\n";
	my @block;
	(@block) = (@_);
	foreach $line (@block) {
		chomp $line;
		print "$line\n";
	}
	print "end block\n";
}

sub makeBlock			#super cool recursion I think....
{
	#printBlock(@_);
	my $in = 1;
	my $base;
	my @block;
	($base,@block) = (@_);
	#printf "last element in block is %s\n", $block[-1];
	my @chunk = ();
	$block[0] =~ /^$base(\s*).*$/; 								#get indent
	my $indent = $base.$1;
	my $strip;
	print "=======MAKING A BLOCK=======\nIndent is !$indent!\n" if $debug;
	foreach $strip (@block) {
		chomp $strip;
		if ($strip =~ /^$indent(\S.*)$/ and $in) {	#print lines in the current indent normally
			print "$indent",makeLine($1), "\n";
		} elsif ($strip =~ /^($indent\s+.*)$/) {		#if we get to a more indented block, push onto stack
			print "push to chunk |$1|\n" if $debug;
			push @chunk, $1;									#until end of that block and then make that block
			$in = 0;
		} elsif ($strip =~ /^$indent(\S.*)$/) {		#once we get to the end of that block, make it
			my $tmp = $1;
			printf "$indent\{";
			print " <b1" if $debug or $print;
			print "\n";
			makeBlock($indent,@chunk);
			@chunk = ();
			print "$indent\}";
			print " <b1" if $debug or $print;
			print "\n$indent",makeLine($tmp), "\n";
			$in = 1;
		} elsif ($strip =~ /^\s*#/ || $strip =~ /^\s*$/) {	
			print "$strip\n";
		} else {
			print "$strip <========failed conversion\n";
		}
	}
	
	print "\nchunk is @chunk\n" if $debug;
	
	if (@chunk) {
		print "lcb\n" if $debug or $print;
		print "$indent\{";
		print " <b2" if $debug or $print;
		print "\n";
		makeBlock($indent,@chunk);
		print "$indent\}";
		print " <b2" if $debug or $print;	
		print "\n";
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

	makeBlock("",@f);
	
}






