%
(init)
G00 (rapid)
G21 (use mm)
G17 (XY plane select)
G90 (absolute programming)
G40 (tool radius compensation: off)
G49 (tool length offset compensation: cancel)
G80 (cancel canned cycle: G73, G81, G83, move z to initial or r-level, either G98 or G99)


G71 (fixed cycle, multiple rep. cycle, for rougting in z axis)
G91.1 (incremental programming, pos defined with ref to prev pos)
T0M06 (select tool 0: Stepcraft Schleppmesser)
G00 (rapid)
G43 (tool height offset compenstation negative, see H)
Z20.000
H0 (tool length offset: 0)
S1 (spindle speed: 1)
M03 (spindle clockwise)

(Toolpath:- Kontur 1)
G94 (feedrate per minute)
X0.000Y0.000F1200.0 (feedrate: 1200mm/min)
G00X1.563Y-11.697Z6.000 (rapid)
G1Z-0.004F900.0 (plunge z at 900mm/min)
G1X-25.000F1200.0 (cut at 1200mm/min)
G2X-25.005Y-11.692I0.000
J0.005 (y axis arc center, see G02, G03)
G1Y9.917





(loop)
(rapidmove)
G00
(down)
G1Z-0.5F900.0
(cutmove)
G01
(up)
G00Z6.000
(endloop)


(end)
G00Z6.000
G00Z20.000
G00X0.000Y0.000
%
