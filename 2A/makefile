#TODO fix this crappy code and make the code independent from course num
.PHONY: all CHE102 ECE222 CS241 ECON102 SE212 STAT206

all: CHE102 ECE222 CS241  ECON102 SE212 STAT206

CHE102:
	@echo "Compiling CHE102"
	@python compiler.py CHE102 > CHE102.tex
	@latex CHE102.tex
	@dvipdfm CHE102.dvi
	@make clean
	@open CHE102.pdf

ECE222:
	@echo "Compiling ECE222"
	@python compiler.py ECE222 > ECE222.tex
	@latex ECE222.tex
	@dvipdfm ECE222.dvi
	@make clean
	@open ECE222.pdf

CS241:
	@echo "Compiling CS241"
	@python compiler.py CS241 > CS241.tex
	@latex CS241.tex
	@dvipdfm CS241.dvi
	@make clean
	@open CS241.pdf

ECON102:
	@echo "Compiling ECON102"
	@python compiler.py ECON102 > ECON102.tex
	@latex ECON102.tex
	@dvipdfm ECON102.dvi
	@make clean
	@open ECON102.pdf

SE212:
	@echo "Compiling SE212"
	@python compiler.py SE212 > SE212.tex
	@latex SE212.tex
	@dvipdfm SE212.dvi
	@open SE212.pdf
	# @make clean

STAT206:
	@echo "Compiling STAT206"
	@python compiler.py STAT206 > STAT206.tex
	@latex STAT206.tex
	@dvipdfm STAT206.dvi
	@make clean
	@open STAT206.pdf

clean:
	./clean.sh

list:
	@echo "CHE102\nECE222\nCS241\nECON102\nSE212\nSTAT206"
