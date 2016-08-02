#!/usr/bin/perl
package main;

use Perfiler;
use strict;
use Data::Dumper;

my $profiler = new Perfiler;
	
sub test {
	my $first = $profiler->start_scope("test 1");
	{
		my $test1 = $profiler->start_scope("test 1");
		function_test("test 1a");
		sleep 1;
	}
	{
		my $test2 = $profiler->start_scope("test 2");
		function_test("test 2a");
		sleep 2;
		{
			my $test1 = $profiler->start_scope("test 2b");
			function_test("test 2ba");
			my $i = 0;
			for ($i;$i<100000;$i++) {
				print ''
			}
		}
	}
	{
		my $test3 = $profiler->start_scope("test 3");
		function_test("test 3a");
		{
			my $test1 = $profiler->start_scope("test 3x");
			my $i = 0;
			for ($i;$i<1000;$i++) {
				print ''
			}
		}
		{
			my $test1 = $profiler->start_scope("test 3x");
			my $i = 0;
			for ($i;$i<1000;$i++) {
				print ''
			}
		}
		{
			my $test1 = $profiler->start_scope("test 3x");
			my $i = 0;
			for ($i;$i<1000;$i++) {
				print ''
			}
		}
		{
			my $test1 = $profiler->start_scope("test 3x");
			sleep 1;
		}
	}
}

sub function_test {
	my $name = shift;
	my $me = $profiler->start_scope($name);
	sleep 2;
}
sub main {
	test;

	my $test = $profiler->get_svg;
	print $test;
}

&main;
