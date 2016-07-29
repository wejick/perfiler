#!/usr/bin/perl
package perfiler;

use strict;
use Time::HiRes qw(gettimeofday tv_interval usleep nanosleep ualarm);
use Data::Dumper;

sub new {
	my ($class, $name, $handler) = @_;	

	$class = ref $class if ref $class;
	my $self = bless {}, $class;
	$self->{name}  = $name;

	#passing global handler for perfiler
	$self->{handler} = $handler;
	$self->{timer} = [gettimeofday()];
	$self->{level} = $self->{handler}->{level}++; #increament the level
	
	return $self;
}

DESTROY {
	my ($self) = @_;
	my $elapse_ms = tv_interval($self->{timer})*1000;
	my %data = (
		name => $self->{name},
		elapse_ms => $elapse_ms,
		started_at => $self->{timer},
		level => $self->{level}, 
		);
	
	my $pos = scalar @{$self->{handler}->{data}};

	$self->{handler}->{data}[$pos] = \%data;
	
	$self->{handler}->{level}--; #decreament the level
}


1;