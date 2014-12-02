#!/bin/bash
sleep 0.1
filename="$1"
cat header.html > ${filename}.html
cat ${filename}.md.html >> ${filename}.html
rm ${filename}.md.html
# cat header.html "$1" > ${filename%.*}.html
