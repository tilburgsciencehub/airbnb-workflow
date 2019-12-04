all: download clean_raw audit

download: download.py
	python download.py

clean_raw: clean.do
	stata-mp -s do clean.do

rule audit: audit.do
	stata-mp -s do audit.do

clean:
	rm *.smcl