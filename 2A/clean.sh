if [ -e "partial.*" ]; then
  rm partial.pdf
  rm partial.tex
fi
find . -name "*.aux" -delete
find . -name "*.log" -delete
find . -name "*.toc" -delete
find . -name "*.out" -delete
find . -name "*.dvi" -delete
