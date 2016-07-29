#!/usr/bin/perl
package main;

use perfiler;
use Data::Dumper;

my %perfilerHandler = (
	level => 0,
	data => []
);

{
	my $profiler = new perfiler("Testing",\%perfilerHandler);
	{
		my $profiler = new perfiler("Testing",\%perfilerHandler);
	}
}
print Dumper($perfilerHandler{data});