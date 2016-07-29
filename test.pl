#!/usr/bin/perl
package main;

use PerfilerCore;
use JSON;
use Data::Dumper;

my %perfilerHandler = (
	level => 0,
	data => []
);

{
	my $profiler = new PerfilerCore("Testing",\%perfilerHandler);
	{
		my $profiler = new PerfilerCore("Testing",\%perfilerHandler);
	}
}
print Dumper($perfilerHandler{data});
my $j = new JSON;
print encode_json($perfilerHandler{data});