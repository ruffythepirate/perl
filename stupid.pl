#!/usr/bin/perl

my $search_string;
my $regexFlags;
my $shouldPrintInfo = FALSE;

foreach $parameter (@ARGV) {
	my @parameterValues = split(/=/, $parameter);
	my $key = $parameterValues[0];
	my $value = join("=", @parameterValues[1..scalar(@parameterValues)]);
	if ($key =~ /^regex$/i) 
{$search_string = $value }
	elsif ($key =~ /^regexflags$/i)
{ $regexFlags = $value }
	else { $shouldPrintInfo = TRUE; }
}


