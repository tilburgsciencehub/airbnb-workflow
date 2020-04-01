all: download clean_raw audit analysis tex_writing

# directories
INPUT = input
SRC = src
GEN = generated
# sub-directories
DATA = data
ANALYSIS = analysis
PAPER = paper
# sub-sub-directories
AUDIT = audit
TEMP = temp
OUTPUT = output
# sub-sub-sub-directories
LOG = log
FIGURE = figure
TABLE = table

# STATA_BIN as STATA environmental variable
STATA = ${STATA_BIN}  

# summary
download: $(INPUT)/calendar.csv $(INPUT)/listings.xlsx $(INPUT)/reviews.xlsx
clean_raw: $(GEN)/$(DATA)/$(TEMP)/calendar.dta $(GEN)/$(DATA)/$(TEMP)/listings.dta $(GEN)/$(DATA)/$(TEMP)/reviews.dta
audit: $(GEN)/$(DATA)/$(AUDIT)/$(LOG)/audit.log
analysis: $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)/analysis.log
tex_writing: $(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx $(GEN)/$(PAPER)/$(TEMP)/analysis.txt

## In detail
# download
$(INPUT)/calendar.csv $(INPUT)/listings.xlsx $(INPUT)/reviews.xlsx: $(SRC)/$(DATA)/download.py
	python $(SRC)/$(DATA)/download.py

# clean_raw
$(GEN)/$(DATA)/$(TEMP)/calendar.dta $(GEN)/$(DATA)/$(TEMP)/listings.dta $(GEN)/$(DATA)/$(TEMP)/reviews.dta: $(SRC)/$(DATA)/clean.do
	$(STATA) -e do $(SRC)/$(DATA)/clean.do
	mv clean.log $(GEN)/$(DATA)/$(OUTPUT)/$(LOG)
	python $(SRC)/$(DATA)/error_check.py $(GEN)/$(DATA)/$(OUTPUT)/$(LOG)/clean.log

# audit
$(GEN)/$(DATA)/$(AUDIT)/$(LOG)/audit.log: $(SRC)/$(DATA)/audit.do
	$(STATA) -e do $(SRC)/$(DATA)/audit.do
	mv audit.log $(GEN)/$(DATA)/$(AUDIT)/$(LOG)
	python $(SRC)/$(DATA)/error_check.py $(GEN)/$(DATA)/$(AUDIT)/$(LOG)/audit.log

# analysis
$(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)/analysis.log: $(SRC)/$(ANALYSIS)/analysis.do
	$(STATA) -e do $(SRC)/$(ANALYSIS)/analysis.do
	mv analysis.log $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)
	python $(SRC)/$(DATA)/error_check.py $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)/analysis.log	

# tex_writing
$(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx $(GEN)/$(PAPER)/$(TEMP)/analysis.txt: $(SRC)/$(PAPER)/table2fill.py $(SRC)/$(PAPER)/tablefill.pl $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(TABLE)/analysis.txt $(SRC)/$(PAPER)/airbnbedit.lyx
	python $(SRC)/$(PAPER)/table2fill.py $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(TABLE)/analysis.txt
	perl $(SRC)/$(PAPER)/tablefill.pl -i $(GEN)/$(PAPER)/$(TEMP)/analysis.txt -t "$(SRC)/$(PAPER)/airbnbedit.lyx" -o "$(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx"


.PHONY: clean
clean:
	RM -f -r "$(GEN)"
	RM -f -r "$(INPUT)"
