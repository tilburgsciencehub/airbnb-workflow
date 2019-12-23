all: analysis

TEMP_DIR = ../temp
OUTPUT_DIR = ../output
INPUT_DIR = ../../preclean/temp

# STATA = ${STATA_BIN}  
STATA = stata-mp

analysis: $(INPUT_DIR)/calendar.dta $(INPUT_DIR)/listings.dta $(INPUT_DIR)/reviews.dta

analysis: analysis.do
	$(STATA) -s do analysis.do

.PHONY: clean
clean:
	-rm *.smcl
	