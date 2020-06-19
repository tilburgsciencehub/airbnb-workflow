# TiSEM reproducible science workflows: AirBnB dataset

Hannes Datta, h.datta@tilburguniversity.edu
Hulai Zhang, h.zhang_4@tilburguniversity.edu



## Dependencies

Please follow the installation guide on 
https://hannesdatta.github.io/reproducible-science-guide/.

- Install Python

  - Anaconda is recommended. [Download Anaconda](https://www.anaconda.com/distribution/).
  - check availability: type `anaconda --version` in the command line.
- Install Kaggle package

  - [Kaggle API](https://github.com/Kaggle/kaggle-api) instruction for installation and setup.
- Install Automation tools 
  - GNU make: already installed in Mac and Linux OS. [Download Make](http://gnuwin32.sourceforge.net/packages/make.htm) for Windows OS and install.
  - Windows OS users only: make `Make` available via the command line. 
    - Right Click on `Computer`
    - Go to `Property`, and click `Advanced System Settings `
    - Choose `Environment Variables`, and choose `Path` under the system variables, click `edit`
    - Add the bin of `Make`
  - check availability: type `make --version` in the command line.
- Install Stata

  - making Stata available via the command line. [Instruction](https://hannesdatta.github.io/reproducible-science-guide/setup/stata/) for adding Stata to path.
  - check availability: type `$STATA_BIN --version` in the command line.
- Install Perl

  - Perl is already installed in Mac and Linux OS. [Download Perl](https://www.perl.org/get.html) for Windows OS.
  - Make sure Perl available via the command line.
  - check availability: type `perl -v` in the command line.

- Install Lyx
  - Lyx is an open source document processor based on the LaTeX. [Download Lyx](https://www.lyx.org/Download).
  - make sure Lyx available via the command line.
  - check availability: type `$LYX_BIN` in the command line.

## How to run it

Open your command line tool:

- Check whether your present working directory is  `tisem-airbnb` by typing `pwd` in terminal

  - if not, type `cd yourpath/tisem-airbnb` to change your directory to `tisem-airbnb`

- Type `make` in the command line.

  

## Directory structure

Make sure `makefile` is put in the present working directory. The directory structure for the Airbnb project  is shown below.

```text
├── data
├── gen
│   ├── analysis
│   │   ├── input
│   │   ├── output
│   │   │   ├── figure
│   │   │   ├── log
│   │   │   └── table
│   │   └── temp
│   ├── data_preparation
│   │   ├── audit
│   │   │   ├── figure
│   │   │   ├── log
│   │   │   └── table
│   │   ├── input
│   │   ├── output
│   │   │   ├── figure
│   │   │   ├── log
│   │   │   └── table
│   │   └── temp
│   └── paper
│       ├── input
│       ├── output
│       └── temp
└── src
    ├── analysis
    ├── data_preparation
    └── paper
```

- **gen**: all generated files such as tables, figures, logs.
  - Three parts: **data_preparation**, **analysis**, and **paper**.
  - **audit**: put the resulting log/tables/figures of audit program. It has three sub-folders: **figure**, **log**, and **table**.
  - **temp** : put the temporary files, such as some intermediate datasets. We may delete these filed in the end.
  - **output**: put results, including the generated figures in sub-folder **figure**, log files in sub-folder **log**, and tables in sub-folder **table**.
  - **input**: put all temporary input files
- **data**: all raw data.
- **src**: all source codes.
  - Three parts: **data_preparation**, **analysis**, and **paper** (including tex files).




