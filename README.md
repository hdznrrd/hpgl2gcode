# hpgl2gcode

(c) 2018-03-26 hadez@infuanfu.de

## Abstract

This little helper converts HPGL files generated by InkCut to GCode.

## Limitations: HPGL

The functionality is very limited and only understands the following HPGL commands:

* IN (initialize, ignored)
* PS (pen select)
* PU (movement with pen up)
* PD (movement with pen down)

## Limitations: GCode

The following assumptions were made:

* HPGL pens are indexed starting with 1, GCode indexes tools starting at 0. This was mapped with a hard offset of -1.
* Machine is assumed to be in absolute coordinate mode (s. init file)
* Machine is assumed to be initialized to using millimeters  (s. init file)
* Work coordinate system is assumed to be zeroed on work surface

Feed rates, z plunge depth and z-hight over work piece for rapids can be configured in the perl script.
