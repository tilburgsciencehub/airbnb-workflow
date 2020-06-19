all: download clean_raw audit analysis tex_writing

# directories
DATA = data
SRC = src
GEN = generated
# sub-directories
DATA_PREP = data_preparation
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
# LYX_BIN as LYX environmental variable
STATA = ${STATA_BIN}  
LYX = ${LYX_BIN}

# summary
download: $(DATA)/calendar.csv $(DATA)/listings.xlsx $(DATA)/reviews.xlsx
clean_raw: $(GEN)/$(DATA_PREP)/$(TEMP)/calendar.dta $(GEN)/$(DATA_PREP)/$(TEMP)/listings.dta $(GEN)/$(DATA_PREP)/$(TEMP)/reviews.dta
audit: $(GEN)/$(DATA_PREP)/$(AUDIT)/$(LOG)/audit.log
analysis: $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)/analysis.log
tex_writing: $(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx $(GEN)/$(PAPER)/$(TEMP)/analysis.txt

## In detail
# download
$(DATA)/calendar.csv $(DATA)/listings.xlsx $(DATA)/reviews.xlsx: $(SRC)/$(DATA_PREP)/package_check.py $(SRC)/$(DATA_PREP)/download.py
	python $(SRC)/$(DATA_PREP)/package_check.py
	python $(SRC)/$(DATA_PREP)/download.py

# clean_raw
$(GEN)/$(DATA_PREP)/$(TEMP)/calendar.dta $(GEN)/$(DATA_PREP)/$(TEMP)/listings.dta $(GEN)/$(DATA_PREP)/$(TEMP)/reviews.dta: $(SRC)/$(DATA_PREP)/clean.do
	$(STATA) -e do $(SRC)/$(DATA_PREP)/clean.do
	mv clean.log $(GEN)/$(DATA_PREP)/$(OUTPUT)/$(LOG)
	python $(SRC)/$(DATA_PREP)/error_check.py $(GEN)/$(DATA_PREP)/$(OUTPUT)/$(LOG)/clean.log

# audit
$(GEN)/$(DATA_PREP)/$(AUDIT)/$(LOG)/audit.log: $(SRC)/$(DATA_PREP)/audit.do
	$(STATA) -e do $(SRC)/$(DATA_PREP)/audit.do
	mv audit.log $(GEN)/$(DATA_PREP)/$(AUDIT)/$(LOG)
	python $(SRC)/$(DATA_PREP)/error_check.py $(GEN)/$(DATA_PREP)/$(AUDIT)/$(LOG)/audit.log

# analysis
$(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)/analysis.log: $(SRC)/$(ANALYSIS)/analysis.do
	$(STATA) -e do $(SRC)/$(ANALYSIS)/analysis.do
	mv analysis.log $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)
	python $(SRC)/$(DATA_PREP)/error_check.py $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(LOG)/analysis.log	

# tex_writing
$(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx $(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.pdf $(GEN)/$(PAPER)/$(TEMP)/analysis.txt: $(SRC)/$(PAPER)/table2fill.py $(SRC)/$(PAPER)/tablefill.pl $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(TABLE)/analysis.txt $(SRC)/$(PAPER)/airbnbedit.lyx
	python $(SRC)/$(PAPER)/table2fill.py $(GEN)/$(ANALYSIS)/$(OUTPUT)/$(TABLE)/analysis.txt
	perl $(SRC)/$(PAPER)/tablefill.pl -i $(GEN)/$(PAPER)/$(TEMP)/analysis.txt -t "$(SRC)/$(PAPER)/airbnbedit.lyx" -o "$(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx"
	$(LYX) -e pdf2 "$(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx"
#	rm "$(GEN)/$(PAPER)/$(OUTPUT)/airbnbfinal.lyx"


.PHONY: clean
clean:
	RM -f -r "$(GEN)"
	RM -f -r "$(DATA)"
