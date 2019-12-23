# requires GNU Make

###### BUILD COMMANDS ######

# full build
all: preclean analysis

.PHONY: all preclean analysis

preclean:
	$(MAKE) -C preclean/code

analysis: 
	$(MAKE) -C analysis/code


