#!/usr/bin/perl
package Perfiler;

use strict;
use PerfilerCore;
use JSON;

my %perfilerHandler = (
	level => 0,
	data => []
);

sub new {
	my $class = shift;
	$class = ref $class if ref $class;
	my $self = bless {}, $class;

	$self->{handler} = \%perfilerHandler;

	return $self;
}

sub start_scope {
	my ($self, $name) = @_;

	return new PerfilerCore($name, \%perfilerHandler);
}

sub get_json {
	my $self = shift;

	return encode_json([reverse @{$self->{handler}->{data}}]);
}

sub get_svg {
	
}

1;