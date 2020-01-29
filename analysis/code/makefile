all: analysis lyx_writing tex_writing

TEMP_DIR = ../temp
OUTPUT_DIR = ../output
INPUT_DIR = ../../preclean/temp

# STATA = ${STATA_BIN}  
STATA = stata

analysis: $(INPUT_DIR)/calendar.dta $(INPUT_DIR)/listings.dta $(INPUT_DIR)/reviews.dta
lyx_writing: $
tex_writing: $

analysis: analysis.do
	$(STATA) -s do analysis.do


lyx_writing: lyx.py

.PHONY: clean
clean:
	-rm *.smcl
	