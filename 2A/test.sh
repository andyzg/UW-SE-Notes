# This shell script is meant for partial LaTeX file testing
# We shouldn't use arguments for makefiles so we'll use this
# script exclusively for testing a latex file

#!/bin/bash
if [ $# != 2 ]; then
  echo "Invalid number of arguments"
  echo "Please pass in the course name, then the class number"
  exit 1
fi

python compiler.py $1 $2 > partial.tex
latex partial.tex
dvipdfm partial.dvi
rm partial.out partial.log partial.aux partial.dvi partial.toc
open partial.pdf
