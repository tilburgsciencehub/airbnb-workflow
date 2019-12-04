## README

### Debug snakemake

[Lachlan’s snakemake-econ-R workshop](https://github.com/lachlandeer/snakemake-econ-r) has the following bugs:

1. The following object `purrr` is masked from `package:magrittr`

   ```R
   library(purrr, warn.conflicts = FALSE)
   ```

2. `Error in make_option(c("-fp", "--filepath"), type = "character", default = NULL,`

   ```R
   make_option(c("-fp", "--filepath") ...
   ```

3. no package called `rticles`

   ```R
   install.packages("rticles")
   ```

4. Many more bugs...



### A collection of pipeline tools

See [Awesome Pipeline](https://github.com/pditommaso/awesome-pipeline) and [Awesome Workflow](https://github.com/meirwah/awesome-workflow-engines). Some popular tools:

- [Dagster](https://github.com/dagster-io/dagster)/[Dask](https://github.com/dask/dask)/[Kedro](https://github.com/quantumblacklabs/kedro)/[Pachyderm](https://github.com/pachyderm/pachyderm)/[Reflow](https://github.com/grailbio/reflow): for data analysts

- [Airflow](https://github.com/apache/airflow) by Airbnb/[Azkaban](https://github.com/azkaban/azkaban) by Linkedin: for programmers
- [Cmake](https://cmake.org/)/[Scons](https://scons.org/): general make tools
- [Bazel](https://bazel.build): Google's next generation build system



### Data preclean and analysis

1. Install [Kaggle API](https://github.com/Kaggle/kaggle-api) for Python
2. Add Stata to `/.bashrc`: [Tutorial](https://www.stata.com/support/faqs/mac/advanced-topics/#batch)



### Snakemake

```makefile
rule download:
	shell:
		"python code/download.py"

rule clean_raw:
	shell:
  	"stata-mp code/clean.do"

rule audit:
	shell:
  	"stata-mp code/audit"
```

More advanced version:

```makefile
rule download:
	shell:
  	"python code/download.py"

rule clean_raw:
	input:
		"input/calendar.dta"
		"input/listings.dta"
	output:
		""
  shell:
  	"stata-mp {input} code/clean.do"
```



### GNU make

```makefile
all: download clean_raw audit  # run all 3 programs

download: download.py
	python download.py

clean_raw: clean.do
	stata-mp -s do clean.do

rule audit: audit.do
	stata-mp -s do audit.do

clean:
	rm *.smcl  # remove all *.smcl by `make clean`
```

### Tree: folders and files

18 directories, 40 files
├── README.md
├── _DS_Store
├── analysis
│   ├── _DS_Store
│   ├── code
│   │   ├── Makefile
│   │   ├── Snakefile
│   │   └── analysis.do
│   ├── input
│   ├── output
│   │   ├── figure
│   │   │   └── available.pdf
│   │   └── table
│   │       ├── probit_avail.txt
│   │       ├── reg_price.txt
│   │       └── sum_listings.txt
│   └── temp
├── preclean
│   ├── _DS_Store
│   ├── audit
│   │   ├── _DS_Store
│   │   ├── figure
│   │   │   ├── available.pdf
│   │   │   ├── pri_accom.pdf
│   │   │   ├── pri_rating.pdf
│   │   │   ├── price.pdf
│   │   │   ├── rating_review.pdf
│   │   │   ├── review_scores_rating.pdf
│   │   │   └── reviews_per_month.pdf
│   │   ├── log
│   │   │   └── on_run.log
│   │   └── table
│   │       ├── sum_cal.txt
│   │       └── sum_listings.txt
│   ├── code
│   │   ├── Makefile
│   │   ├── Snakefile
│   │   ├── _DS_Store
│   │   ├── audit.do
│   │   ├── clean.do
│   │   ├── download.py
│   │   └── preclean
│   ├── input
│   │   ├── _DS_Store
│   │   ├── calendar.csv
│   │   ├── listings.xlsx
│   │   ├── reviews.xlsx
│   │   ├── ~$listings.xlsx
│   │   └── ~$reviews.xlsx
│   ├── output
│   │   ├── dataset
│   │   └── log
│   │       └── clean_raw.log
│   └── temp
│       ├── calendar.dta
│       ├── listings.dta
│       └── reviews.dta
└── tree.md
