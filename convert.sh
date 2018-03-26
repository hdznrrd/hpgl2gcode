#!/bin/sh

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "%"
echo "(INIT START)"
cat "$DIR/init_dragknife.nc"
echo "(INIT START)"
echo "(TOOL PATH START)"
cat $1 | "$DIR/hpgl2gcode.pl"
echo "(TOOL PATH END)"
echo "(END START)"
cat "$DIR/end.nc"
echo "(END END)"
echo "%"
