#!/usr/bin/perl
package main;

use Perfiler;

my $profiler = new Perfiler;

{
	my $me = $profiler->start_scope("test 1");
	{
		my $you = $profiler->start_scope("test 2");
		{
			my $bro = $profiler->start_scope("test 3");
		}
		{
			my $store = $profiler->start_scope("test 4");
		}
	}
}
print $profiler->get_json;