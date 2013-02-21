#!/usr/bin/perl
use strict;

package FileReader;

sub new
{
	my $class = shift;
	my $self = {
		_fileName => shift
	};

	bless $self, $class;

	return $self;
}

#
# This subroutine opens the file for reading.
#
# Return Values:
# 0 if the file was not opened.
# -1 if the file doesn't exist.
# -2 if the file is not a file.
# -3 if the file is not readable.
# 1 if the file was successfully opened.
#
sub open
{
	my ($self) = @_;
	my $rtn = 0;

	my $file = $self->{_fileName};

	
	if(!(-e $file))		# Check if the file exists.
	{
		$rtn = -1;
	}
	elsif(!(-r $file))	# Check if the file is readable.
	{
		$rtn = -3;
	}
	elsif(!(-f $file))	# Check if the file is a file.
	{
		$rtn = -2;
	}
	else
	{
		if(open($self->{_fileHandle}, "< $file"))
		{
			$rtn = 1;
		}
		else
		{
			$rtn = 0;
		}
	}

	return $rtn;
}

#
# This subroutine will close the file handle.
#
# Return Values:
# 1 if successful
# 0 if unsuccessful
# -1 if the file handle is already closed or not initialized.
#
sub close
{
	my ($self) = @_;
	my $rtn = 0;

	if($self->{_fileHandle})
	{
		if(close($self->{_fileHandle}))
		{
			$rtn = 1;
		}
	}
	else
	{
		$rtn = -1;
	}

	return $rtn;
}

#
# This subroutine will iterate through each line of the file and
# call the line handler subroutine reference.
#
# Return Values:
# 1 if all goes well.
# 0 if something goes wrong.
#
sub process
{
	my ($self, $handler) = @_;
	my $rtn = 0;

	if($self->{_fileHandle})
	{
		my $handle = $self->{_fileHandle};
		while(<$handle>)
		{
			chomp;

			$handler->($_);
		}

		$rtn = 1;
	}
	else
	{
		$rtn = 0;
	}

	return $rtn;
}

#
# This subroutine return the file name that was passed during initialization.
#
sub getFileName
{
	my ($self) = @_;

	return $self->{_firstName};
}

1;
