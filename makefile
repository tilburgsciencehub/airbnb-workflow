all: download clean_raw audit analysis tex_writing

CODE_DIR = code
TEMP_DIR = temp
OUTPUT_DIR = output
INPUT_DIR = input
AUDIT_DIR = audit
WRITING_DIR = writing

# STATA = ${STATA_BIN}  
STATA = stata

download: $(INPUT_DIR)/calendar.csv $(INPUT_DIR)/listings.xlsx $(INPUT_DIR)/reviews.xlsx
clean_raw: $(TEMP_DIR)/calendar.dta $(TEMP_DIR)/listings.dta $(TEMP_DIR)/reviews.dta
audit: $(AUDIT_DIR)/log/audit.log
analysis: $(OUTPUT_DIR)/log/analysis.log
tex_writing: $(WRITING_DIR)/airbnbfinal.lyx $(OUTPUT_DIR)/table/analysis.txt

$(INPUT_DIR)/calendar.csv $(INPUT_DIR)/listings.xlsx $(INPUT_DIR)/reviews.xlsx: $(CODE_DIR)/download.py
	python $(CODE_DIR)/download.py

$(TEMP_DIR)/calendar.dta $(TEMP_DIR)/listings.dta $(TEMP_DIR)/reviews.dta: $(CODE_DIR)/clean.do
	$(STATA) -e do $(CODE_DIR)/clean.do
	mv clean.log $(OUTPUT_DIR)/log
	python $(CODE_DIR)/error_check.py $(OUTPUT_DIR)/log/clean.log

$(AUDIT_DIR)/log/audit.log: $(CODE_DIR)/audit.do
	$(STATA) -e do $(CODE_DIR)/audit.do
	mv audit.log $(AUDIT_DIR)/log
	python $(CODE_DIR)/error_check.py $(AUDIT_DIR)/log/audit.log

$(OUTPUT_DIR)/log/analysis.log: $(CODE_DIR)/analysis.do
	$(STATA) -e do $(CODE_DIR)/analysis.do
	mv analysis.log $(OUTPUT_DIR)/log
	python $(CODE_DIR)/error_check.py $(OUTPUT_DIR)/log/analysis.log	

$(WRITING_DIR)/airbnbfinal.lyx $(OUTPUT_DIR)/table/analysis.txt: $(CODE_DIR)/table2fill.py $(CODE_DIR)/tablefill.pl
	python $(CODE_DIR)/table2fill.py $(OUTPUT_DIR)/table/analysis.txt
	perl $(CODE_DIR)/tablefill.pl -i $(OUTPUT_DIR)/table/analysis.txt -t "$(WRITING_DIR)/airbnbedit.lyx" -o "$(WRITING_DIR)/airbnbfinal.lyx"


.PHONY: clean
clean:
	RM -f -r "$(TEMP_DIR)"
	RM -f -r "$(OUTPUT_DIR)"
	RM -f -r "$(INPUT_DIR)"
	

# all: analysis lyx_writing tex_writing

# TEMP_DIR = ../temp
# OUTPUT_DIR = ../output
# INPUT_DIR = ../../preclean/temp

# # STATA = ${STATA_BIN}  
# STATA = stata

# analysis: $(INPUT_DIR)/calendar.dta $(INPUT_DIR)/listings.dta $(INPUT_DIR)/reviews.dta
# lyx_writing: $
# tex_writing: $

# analysis: analysis.do
# 	$(STATA) -s do analysis.do


# lyx_writing: tablefill.pl
	

# .PHONY: clean
# clean:
# 	-rm *.smcl