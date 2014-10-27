#!/bin/bash
if [ $# == 0 ]; then
  for COURSE in $( ls -d */ ); do
    if [[ "template/" =~ $COURSE ]]; then
      continue
    fi
    ./make.sh ${COURSE%?}
  done
  exit 0
fi

if [ $# != 1 ] && [ $# != 2 ]; then
  exit 1
fi

echo "Compiling $1\n\n\n"
python bundler.py $1 > "$1.tex"

# LaTeX document needs to be compiled twice for table of contents
latex "$1.tex"
dvipdfm "$1.dvi"
latex "$1.tex"
dvipdfm "$1.dvi"

if [ $# == 2 ]; then
  open "$1.pdf"
fi
./clean.sh

exit 0
