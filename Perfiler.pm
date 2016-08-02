#!/usr/bin/perl
package Perfiler;

use strict;
use PerfilerCore;
use JSON;
use Time::HiRes qw(tv_interval );

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
	my $width = $SCALE_X * (($x2));
	my $height = $SCALE_Y - 1.0;

	my $text = "<rect class='$svg_class' x='$x' y='$y' width='$width' height='$height' />\n";

	return $text;
}

sub svg_text {
	my ($x, $y, $format, $text_class) = @_;
	
	my $svg_class;
	
	if ($text_class) {
		$svg_class = $text_class;
	}	else {
		$svg_class = 'right';	
	}
			
	my $x = $SCALE_X * ($x) + 5.0;
	my $y = $SCALE_Y * ($y) + 14.0;
	
	my $text = "<text class='$svg_class' x='$x' y='$y'>$format</text>";
	return $text;
}

sub svg_header {
	my ($x,$y) = @_;
	$x = $SCALE_X * $x;
	$y = $SCALE_Y * $y;
	my $header = <<INSERT_STRING;
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="$x px" height="$y px" version="1.1" xmlns="http://www.w3.org/2000/svg">	<!-- This file is a perfiler SVG file. It is best rendered in a browser  -->

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
    $y2 = $height;
    for ($i = (($begin / 100000)) * 1000000; $i <= $end+(100000*10); $i+=100000) {
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
	my $self = shift;
	
	my @result = reverse @{$self->{handler}->{data}};	
	my %common_data = ('total_time'=>$result[0]->{elapse_ms}, 'total_scope'=>scalar @result);
	
	my $svg;
	my $header = svg_header($common_data{total_time}*1000,$common_data{total_scope}+10);
	my $footer = svg_footer;
	
	$svg = $header;
	$svg .= svg_text(5*10000,1,"Perfiler Result :",'left');
	$svg .= svg_text(5*10000,2,"Elapse time is $common_data{total_time} ms with $common_data{total_scope} scope measured",'left');
	$svg .= " <g transform='translate(20.000,80)'> \n";
	$svg .= svg_box($common_data{total_scope},0,$common_data{total_time}*1000);
	
	my $y = 0;
	foreach my $item (@result){
		my $x_offset = tv_interval(($result[0]->{started_at}),$item->{started_at}) * 1000000;

		$svg .= svg_bar("function",$x_offset,$item->{elapse_ms}*1000,$y);
		$svg .= svg_text($x_offset,$y,"$item->{elapse_ms} ms $item->{name}",$x_offset < 50 ? 100:$x_offset);
		$y++;
	}
	
	$svg .= " </g>\n";
	$svg .= $footer;

	return $svg;
}

1;
