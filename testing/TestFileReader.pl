#!/usr/bin/perl

################################################################################
#
# Copyright(c) 2013 - CodersHaven.net
#
# Name: 	TestFileReader.pl
# Author:	CodersHaven.net
# Email:	ch.lab@codershaven.net
# Description:	This program provides an example of how to use the FileManager
#		class.
#
################################################################################

use strict;
use lib "../src";

# Import our FileReader package.
use FileReader;

# Define our process subroutine prototype.
sub process($);

# Initialize our file name from the command line arguments.
my $fileName = shift(@ARGV);

# Create a global hash which will be used to summarize the number of
# cars by year.
our %countByYear = ();

print<<END;
Processing file $fileName
===================================
END

# Create an instance of our FileReader class.
my $fr = new FileReader($fileName);

# Open the file.
if($fr->open() > 0)
{
	# Pass a reference to our local process subroutine to the file reader
	# process function.
	if(!$fr->process(\&process))
	{
		print STDERR "Unable to process the file.\n";
	}

	# Close the file.
	$fr->close();
}
else
{
	print STDERR "Unable to open the file $fileName.\n";
	exit(1);
}

print<<END;


Cars by Year Summary
====================

Year\t\tCars
------------------------
END

# Display the cars by year summary.
foreach my $year (sort(keys(%countByYear)))
{
	if($year ne "YEAR")
	{
		print "$year\t\t$countByYear{$year}\n";
	}
}

# Definition of the local process subroutine.
sub process($)
{
	my $line = shift;

	my @tmp = split(/,/, $_);

	print "$tmp[0]|$tmp[2]\n";

	if(defined($countByYear{$tmp[0]}))
	{
		$countByYear{$tmp[0]}++;
	}
	else
	{	
		$countByYear{$tmp[0]} = 1;
	}
}
