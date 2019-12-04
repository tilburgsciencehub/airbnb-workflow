all: analysis

analysis: analysis.do
	stata-mp -s do analysis.do

.PHONY: clean
clean:
	-rm *.smcl
	