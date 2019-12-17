## TiSEM reproducible science workflows: AirBnB dataset

Put project description here.
You can use multiple lines, but keep
the width of the text limited to the
header.

Hannes Datta, h.datta@tilburguniversity.edu
Hulai Zhang, ...


### Build instructions

### Dependencies

Please follow the installation guide on 
https://hannesdatta.github.io/reproducible-science-guide/.

- Install Python (LINK HERE)
  o also install the Kaggle package for Python
  ```pip install kaggle```
  
  See also: https://github.com/Kaggle/kaggle-api

- Install Automation tools (LINK HERE)

- Install R(LINK HERE)
	- Install the following packages:

    ```
	packages <- c("data.table", "ggplot2")

    install.packages(packages)
	```
- Install Stata (LINK HERE)
  
### Directory structure

@ Hulai, adapt

\raw           Code required to collect/download raw data
\derived       Data preparation
\analysis      Data analysis
\paper         Stores literature reference, paper, and slides

Each directory contains subdirectories,
    \input (for input files)
    \output (for final output files)
    \temp (for any temporary files)
    \code (for all the code)
    \audit (for any auditing files)

The \code directory contains the makefile, with running descriptions
for each submodule.




### Tree: folders and files

```txt
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
```

### How to run the project

#### GNU make

Navigate to the project's root directory, open a terminal,
and run `make`

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

#### Snakemake

@Hulai, instruction here

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

