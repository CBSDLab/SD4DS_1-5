# Simulation studies on the HPC using Stella Simulator

This set of exercises introduces running Stella model simulation studies on the HPC using Stella Simulator. 

# 1. Cloning this repository in your user directory

The first thing to do is clone this Github repository into the local directory of your user account. This will copy all the files from the respository that you will need for this exercise. To do this, first create a directory to save your SD4DS exercises, e.g., SD4DS. This can be done through the OnDemand Files interface or directly through a terminal.

Create a directory in the terminal called SD4DS with the `mkdir` command.

```         
mkdir SD4DS
```

Move into the directory with the `cd` command.

```         
cd SD4DS
```

Now clone the directory in the terminal with the `git clone` command.

```         
git clone https://github.com/CBSDLab/SD4DS_1-5.git
```

# 2. Testing access to Stella Simulator

Start a compute note with 1 note and start in the bash terminal.

```         
srun -n 1 --pty bash
```

Run the AWK script simulate.sh, which runs a single simulation using Stella Simulator.

```         
awk -f simulate.sh
```

Check to see if the Results.csv file has been updated by listing the files.

```         
ls -l Results.csv
```

# 3.
