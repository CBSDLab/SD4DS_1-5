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

The HPC has head nodes and compute nodes. When you log into the HPC, you log into a head node. Head nodes are *not* to be used for computations. Always use *compute* nodes for any computation. 

When you are working on a head node, you'll see "hpc" in your terminal line prompt along with your current directory, e.g., "[psh39@hpc6 SD4DS_1-5]$". When you are working on a compute node, you'll see "compt" in your terminal prompt along with your working directory, e.g., "[psh39@compt317 SD4DS_1-5]$". 

So the first thing we must do is start a compute node to test our access to Stella Architect. We do this with the `srun` command and providing arguments to specify the number of nodes, CPUs, etc. Start a compute note with 1 note and start in the Bash terminal.

```         
srun -n 1 --pty bash
```

Running simulations can be done interactively through the terminal command, but it's often a lot easier and more reliable to run an AWK shell script. The AWK shell script simulate.sh sets the path to Stella Simulator on the HPC and command for running the model with Stella Simulator, and then executes the command. Run the AWK script simulate.sh.

```         
awk -f simulate.sh
```

If successful, you should see something similar to the following output:
```
Stella Simulator version 3.5.1 (3169), Copyright (C) 2023 by isee systems, inc.
Registered to: Peter S Hovmand, Case Western Reserve University
```

You can also check to see if the simulation updated the Results.csv file, which contains the output from the model, but using the `ls` command.

```         
ls -l Results.csv
```

Finally, exit the session on the compute node with the `exit` command. This releases the compute node resources for other users versus leaving them open and waiting for the session to time out. 

```
exit
```

We're now ready to move forward in running a simulation study. 

# 3. Running simulation study1 interactively

To run the simulation study interactively, we start again by requesting a compute node. 

```         
srun -n 1 --pty bash
```

Next, we load the R module. R modules are constantly being updated with older versions removed. To find the available module, we can use the `spider` command. 

```
module spider R
```

To load the model, we use the `module load` command followed by the module name we want to load. 

```
module load R/4.4.2-gfbf-2024a
```

Once we have successfully loaded the R module, we are now ready to run the simulate_study.sh AWK script, which runs takes a .csv file with the initial conditions and parameter values in each row corresponding to the values to be used for that row. For each simulation, the row for that simulation run is copied to the Parms.csv file. The Stella model is then run in Stella Simulator, which saves the results from the current run in the Results.csv file. We are normally only interested in some variables and values, and these need to be processed into another file for the simulation study results. Hence, simulate_study.sh then calls the process_run.R file, which selects the variables and appends the data frame to the previous results, saving them in study1_results.csv file. 

To run the simulation study interactively, we type:

```
awk -f simulate_study.sh study1.csv
```

Last, exit the session on the compute node. 

```
exit
```

# 4. Running simulation study1 as a batch process


