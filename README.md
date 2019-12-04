## README

### Debug snakelike

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
- [Bazel](https://bazel.build): Google's next generation buid system



### Data preclean and analysis

1. Install [Kaggle API](https://github.com/Kaggle/kaggle-api) for Python
2. Add Stata to .bashrc: [Tutorial](https://www.stata.com/support/faqs/mac/advanced-topics/#batch)
3. 

