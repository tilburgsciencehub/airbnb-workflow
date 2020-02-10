all: download clean_raw audit

TEMP_DIR = ../temp
OUTPUT_DIR = ../output
INPUT_DIR = ../input

# STATA = ${STATA_BIN}  
STATA = stata

download: $(INPUT_DIR)/calendar.csv $(INPUT_DIR)/listings.xlsx $(INPUT_DIR)/reviews.xlsx
clean_raw: $(TEMP_DIR)/calendar.dta $(TEMP_DIR)/listings.dta $(TEMP_DIR)/reviews.dta
audit: $(TEMP_DIR)/calendar.dta $(TEMP_DIR)/listings.dta $(TEMP_DIR)/reviews.dta

$(INPUT_DIR)/calendar.csv $(INPUT_DIR)/listings.xlsx $(INPUT_DIR)/reviews.xlsx: download.py
	python download.py

$(TEMP_DIR)/calendar.dta $(TEMP_DIR)/listings.dta $(TEMP_DIR)/reviews.dta: clean.do
	$(STATA) -s do clean.do

audit: audit.do
	$(STATA) -s do audit.do

.PHONY: clean
clean:
	RM -f -r "$(TEMP_DIR)"
	RM -f -r "$(OUTPUT_DIR)"
	RM -f -r "$(INPUT_DIR)"
	

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


lyx_writing: tablefill.pl
	

.PHONY: clean
clean:
	-rm *.smcl