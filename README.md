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
  - GNU make: already installed in Mac and Linux OS. [Download GNU Make](https://www.gnu.org/software/make/) for Windows OS.
  - check availability: type `make --version` in the command line.
- Install Stata

  - making Stata available via the command line. [Instruction](https://hannesdatta.github.io/reproducible-science-guide/setup/stata/) for adding Stata to path.
  - check availability: type `stata --version` in the command line.
- Install Perl

  - Perl is already installed in Mac and Linux OS. [Download Perl](https://www.perl.org/get.html) for Windows OS.
  - Make sure Perl available via the command line.
  - check availability: type `perl -v` in the command line.



## How to run it

Open your command line tool:

- Check whether your present working directory is  `tisem-airbnb` by typing `pwd` in terminal

  - if not, type `cd yourpath/tisem-airbnb` to change your directory to `tisem-airbnb`

- Type `make` in the command line.

  

## Directory structure

Make sure `makefile` is put in the present working directory. The directory structure for the Airbnb project  is shown below.

```text
├── generated
│   ├── analysis
│   │   ├── audit
│   │   ├── input
│   │   ├── output
│   │   │   ├── figure
│   │   │   ├── log
│   │   │   └── table
│   │   └── temp
│   ├── data
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
│       ├── audit
│       ├── output
│       └── temp
├── input
└── src
    ├── analysis
    ├── data
    └── paper
```

- **generated**: all generated files such as tables, figures, logs.
  - Three parts: **data**, **analysis**, and **paper**.
  - **audit**: put the resulting log/tables/figures of audit program. It has three sub-folders: **figure**, **log**, and **table**.
  - **temp** : put the temporary files, such as some intermediate datasets. We may delete these filed in the end.
  - **output**: put results, including the generated figures in sub-folder **figure**, log files in sub-folder **log**, and tables in sub-folder **table**.
- **input**: all raw data.
- **src**: all source codes.
  - Three parts: **data**, **analysis**, and **paper** (including tex files).




