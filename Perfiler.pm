#!/usr/bin/perl
package Perfiler;

use strict;
use PerfilerCore;
use JSON;

my %perfilerHandler = (
	level => 0,
	data => []
);

my $SCALE_X = (0.1 / 1000.0);   #pixels per us
my $SCALE_Y = (20.0);

sub svg_bar {
	my ($svg_class, $x1, $x2, $y) = @_;

	my $x = $SCALE_X * $x1;
	my $y = $SCALE_Y * ($y);
	my $width = $SCALE_X * (($x2) - ($x1));
	my $height = $SCALE_Y - 1.0;

	my $text = "<rect class='$svg_class' x='$x' y='$y' width='$width' height='$height' />\n";

	return $text;
}

sub svg_text {
	my ($x, $y, $format) = @_;
	my $svg_class = "right";
	my $x = $SCALE_X * ($x) + 5.0;
	my $y = $SCALE_Y * ($y) + 14.0;
	
	my $text = "<text class='$svg_class' x='$x' y='$y'>$format</text>";
	return $text;
}

sub svg_header {
	my $header = <<INSERT_STRING;
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="854px" height="603px" version="1.1" xmlns="http://www.w3.org/2000/svg">	<!-- This file is a perfiler SVG file. It is best rendered in a browser  -->

	<defs>
  	<style type="text/css">
    <![CDATA[
      rect       { stroke-width: 1; stroke-opacity: 0; }
      rect.background   { fill: rgb(255,255,255); }
      rect.function   { fill: rgb(255,0,0); fill-opacity: 0.7; }
      rect.box   { fill: rgb(240,240,240); stroke: rgb(192,192,192); }
      line       { stroke: rgb(64,64,64); stroke-width: 1; }
      line.sec5  { stroke-width: 2; }
      line.sec01 { stroke: rgb(224,224,224); stroke-width: 1; }
      text       { font-family: Verdana, Helvetica; font-size: 14px; }
      text.left  { font-family: Verdana, Helvetica; font-size: 14px; text-anchor: start; }
      text.right { font-family: Verdana, Helvetica; font-size: 14px; text-anchor: end; }
      text.sec   { font-size: 10px; }
    ]]>
   	</style>
	</defs>
	<rect class="background" width="100%" height="100%" />
INSERT_STRING

	return $header;
}

sub svg_box {
	my ($height, $begin, $end) = @_;
	my $i;
	my $box;

	my $width = $SCALE_X * ($end-$begin);
	my $height = $SCALE_Y * $height;
    $box = " <rect class='box' x='0' y='0' width='$width' height='$height' />\n";

    my ($svg_class, $x1, $x2, $y1, $y2, $text);
    $y1 = 0;
    $y2 = $SCALE_Y * $height;
    for ($i = (($begin / 100000)) * 1000000; $i <= $end; $i+=100000) {
    	$x1 = $SCALE_X * $i;
    	$x2 = $SCALE_X * $i;
		if ($i % 5000000 == 0) {
			$text = 0.000001 * $i;
			$svg_class = 'sec5';
		} elsif ($i % 1000000 == 0) {
			$text = 0.000001 * $i;
			$svg_class = 'sec1';			
		} else {
			$svg_class = 'sec01';
			$text = '';		 	
		}
		$box .= " <line class='$svg_class' x1='$x1' y1='$y1' x2='$x2' y2='$y2' /> \n";
		if ($text != '') {
			$box .= " <text class='sec' x='$x1' y='-5'> $text s</text> \n";	
		}
    }
    return $box;
}

sub svg_footer {
	my $footer = "</svg>\n";

	return $footer;
}

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
	my $svg;
	my $header = svg_header;
	my $footer = svg_footer;

	$svg = $header;
	$svg .= " <g transform='translate(20.000,100)'> \n";
	$svg .= svg_box(100,0,500*10000);
	$svg .= svg_bar("function",0,5*10000,0);
	$svg .= svg_text(5*10000,0,"jalan");
	$svg .= " </g>\n";
	$svg .= $footer;

	return $svg;
}

1;