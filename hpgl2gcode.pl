#!/usr/bin/perl -W

use strict;
use Switch;

# assumptions:
# - absolute position mode
# - machine origin (0,0,0) placed at surface of work
# - machine set to use millimeter



## CONFIGURATION

# Z positions in mm
my $PEN_DOWN_Z="-1";
my $PEN_UP_Z="5";

# feed rates in mm/min
my $FEED_RATE_XY="1200";
my $FEED_RATE_Z="900";

#my $SCALE=3.614;
my $SCALE=1.0;

## STATE TRACKING FOR OPTIMIZATION
my $STATE__PEN_IS_UP=1;
sub is_pen_up() { return $STATE__PEN_IS_UP; }
sub pen_up() { $STATE__PEN_IS_UP=1; }
sub pen_down() { $STATE__PEN_IS_UP=0; }



## TOP LEVEL PARSER DISPATCH
sub transmute() {
	switch(shift) {
		case 'IN'	{ &transmute_init($_) }
		case /^SP/	{ &transmute_pen_select($_) }
		case /^PU/	{ &transmute_pen_up($_) }
		case /^PD/	{ &transmute_pen_down($_) }
		else		{ &unknown_code($_) }
	}
}



## PARSER FUNCTIONS

# something wrong? stop fatally.
sub unknown_code() {
	die("unknown code: $_$/");
}

# nothing to do here, that's handled in the gcode header already
sub transmute_init() {}

# Select Pen mapped to tool-change command
# note: HPGL pens start at 1, while gcode tools start at 0
sub transmute_pen_select() {
	/^SP(\d+)/;
	# $1 tool id
	&emit_tool_change($1-1);
}

# Pen Up is mapped to a Z+ movement (if needed) and rapid X/Y movement
sub transmute_pen_up() {
	/^PU(\d+),(\d+)/;
	# $1 x *25um
	# $2 y *25um
	&emit_rapid_z($PEN_UP_Z) if(!&is_pen_up());
	&emit_rapid_xy(&hpgl2mm($1),&hpgl2mm($2));
	&pen_up();
}

# Pen Down is mapped to a Z- movement (if needed) and regular X/Y movement
sub transmute_pen_down() {
	/^PD(\d+),(\d+)/;
	# $1 x *25um
	# $2 y *25um
	&emit_rapid_z(0) if(&is_pen_up());
	&emit_z($PEN_DOWN_Z) if(&is_pen_up());
	&emit_xy(&hpgl2mm($1),&hpgl2mm($2));
	&pen_down();
}


# coordinate conversion helper
# HPGL units are 25um aka 40 units per mm
sub hpgl2mm() {
	return ((shift) / 40.0) * $SCALE;
}

## GCODE OUTPUT FUNCTIONS

sub emit_tool_change() {
	printf "T%sM06$/",shift;
}

sub emit_rapid_z() {
	printf "G00Z%s$/",shift;
}

sub emit_rapid_xy() {
	printf "G00X%sY%s$/",shift,shift;
}

sub emit_z() {
	printf "G1Z%sF%s$/",shift,$FEED_RATE_Z;
}

sub emit_xy() {
	printf "G1X%sY%sF%s$/",shift,shift,$FEED_RATE_XY;
}







## MAIN LOOP
while(<>) {
	foreach (split /;/) {
		&transmute($_)
	}
}
