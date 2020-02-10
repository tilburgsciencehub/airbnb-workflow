# TiSEM reproducible science workflows: AirBnB dataset

Hannes Datta, h.datta@tilburguniversity.edu
Hulai Zhang, h.zhang_4@tilburguniversity.edu



## Dependencies

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

- Check whether your present working directory is  `tisem-airbnb` by typing `pwd`

  - if not, type `cd yourpath/tisem-airbnb` to change your directory to `tisem-airbnb`

- Type `make` in the command line.

  

## Directory structure

Make sure `makefile` is put in the present woring directory. The directory structure for the Airbnb project  is shown below.

```text
├── audit
│   ├── figure
│   ├── log
│   └── table
├── code
├── input
├── output
│   ├── figure
│   ├── log
│   └── table
├── paper
├── temp
└── writing
```

Here are the details of the directory structure:

1. **audit** is the folder where we put the resulting log/tables/figures of audit program. It has three sub-folders: **figure**, **log**, and **table**.
2. **code** is the folder where we put all programs.
3. **input** is the folder where we put all raw data.
4. **output** is the folder where we put results, including the generated figures in sub-folder **figure**, log files in sub-folder **log**, and tables in sub-folder **table**.
5. **paper** is the folder where we put the literature.
6. **temp** is the folder where we put the temporary files, such as some intermediate datasets. We may delete these filed in the end.
7. **writing** is the folder where we put our writings, such as tex files.




