#!/usr/bin/perl

my $search_string;
my $shouldRun = TRUE;

foreach $parameter (@ARGV) {
	my @parameterValues = split(/=/, $parameter);
	my $key = $parameterValues[0];
	my $value = join("=", @parameterValues[1..scalar(@parameterValues) - 1]);
	if ($key =~ /^regex$/i) 
{$search_string = $value }
	else { $shouldRun = FALSE;}
}

$shouldRun = $shouldRun && length($search_string) > 0;

if($shouldRun) {

my %sortStrings;
while ( defined( $line = <STDIN> ) ) {
	if($line =~ m/$search_string/) 
	{
		if(!exists $sortStrings{$1})
{
		@{$sortStrings{$1}} = ($line);
} else { push(@{$sortStrings{$1}}, $line); }
	} else {
		if(%sortStrings)
		{
			#We sort the data and print it.
foreach $key (sort keys %sortStrings) {
	foreach $currentline (sort @{$sortStrings{$key}}) {
     print "$currentline";
}
}
%sortStrings = {};
		}
		print "$line";
	}
}
foreach $key (sort keys %sortStrings) {
	foreach $currentline (sort @{$sortStrings{$key}}) {
     print "$currentline";
}
}} else {
	print "Usage: perl CodeQuickSort.pl regex=<regex> < <file to transform> > <data output>. \n";
	print "Note: The regex must contain at least one matching pair of parantheses, the code rows will be sorted based on the content of these parantheses! \n";
	
}