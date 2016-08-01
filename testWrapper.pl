#!/usr/bin/perl
package main;

use Perfiler;
use strict;

	my $profiler = new Perfiler;
	
sub test {
	my $me = $profiler->start_scope("test 1");
	{
		my $you = $profiler->start_scope("test 2");
		{
			my $bro = $profiler->start_scope("test 3");
			my $a = 'a';
		}
		{
			my $store = $profiler->start_scope("test 4");
			my $a = 'a';
		}
		{
			my $store = $profiler->start_scope("test 5");
			my $a = 'a';
		}
	}
	my $a = 'a';
}

sub main {
	test;

	#print $profiler->get_json;
	print $profiler->get_svg;
}

&main;