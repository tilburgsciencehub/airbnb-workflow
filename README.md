## TiSEM reproducible science workflows: AirBnB dataset

Hannes Datta, h.datta@tilburguniversity.edu
Hulai Zhang, h.zhang_4@tilburguniversity.edu



### Dependencies

Please follow the installation guide on 
https://hannesdatta.github.io/reproducible-science-guide/.

- Install Python
  
  - Anaconda is recommended. [Download Anaconda](https://www.anaconda.com/distribution/).
  
  - also install and set up the Kaggle package for Python. [Kaggle API](https://github.com/Kaggle/kaggle-api) instruction for setting up.
  
- Install Automation tools 

  - GNU make: already installed in Mac and Linux OS. [Download GNU Make](https://www.gnu.org/software/make/) for Windows OS.

- Install Stata
  
  - making Stata available via the command line. [Instruction](https://hannesdatta.github.io/reproducible-science-guide/setup/stata/) for adding Stata to path.
  
- Install Perl

  - Perl is already installed in Mac and Linux OS. [Download Perl](https://www.perl.org/get.html) for Windows OS.
  - Make sure Perl available via the command line.



## How to run it

Open your command line tool:

- Check that your present working directory is  `tisem-airbnb` by typing `pwd`
  - if not, type `cd yourpath/tisem-airbnb` to change your directory to `tisem-airbnb`
- Type `make` in the command line.



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


