# Simulation studies on the HPC using Stella Simulator

This set of exercises introduces running Stella model simulation studies on the HPC using Stella Simulator. The exercises cover the basic steps for checking access to Stella Simulator on the HPC, running an interactive simulation study, and then running a batch simulation study. 

## 1. Cloning this repository in your user directory

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

## 2. Testing access to Stella Simulator

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

## 3. Running simulation study1 interactively

To run the simulation study interactively, we start again by requesting a compute node. 

```         
srun -n 1 --pty bash
```

 we are now ready to run the simulate_study.awk script, which takes a .csv file with the initial conditions and parameter values for each row corresponding to the values to be used for the run. For each simulation, the row for that simulation run is copied to the Parms.csv file and then Stella Simulator is called, which the results from the current run in the Results.csv file. The script then copies the Results.csv file to a unique filename associated with the run, i.e., Result_1.csv, Results_2.csv, etc.

```
awk -f simulate_study.awk -v MODEL="limits to growth.stmx" study1.csv
```

We are normally only interested in some variables and values. For example, depending on how the Stella model is defined, the results from each time step may be saved. For example, the Limits to Growth Model simulates a population from 0 to 100 years in time steps of 1/1024 years for a total of 102,400 points in time for each of the 9 variables in the models or close to 1 million values *per simulation* even though this is a small system dynamics models. 

We are usually only interested in a subset of variables and time points. While we can specify this with the Stella model to reduce the number of values saved and shortern the simulation time and save on disk space, we might not know *a priori* what we are most interested in using in model analysis. Moreover, if we modify the model itself for a particular analysis (e.g., changing the time step from 1/1024 years to 1/4 years), we increase the likelihood of misinterpreting the results. Hence, it is usually best to keep the model the same for all the analyses and select the variables and time points we are interested in post-simulation. 

This is accomplished with the process_results.R script, which looks and combines files with the filenames begining with Results_, selects the variables of interest and then saves the combined file as an .Rdata binary object. You can modify this file to change how you want to read in the files, select variables, and combine results. The process_results.R script is called with the `Rscript` command.

```
Rscript process_results.R
```

Afte this script is called, you'll see the results saved in the study_results.RData file and the temporary files Results_1.csv, Results_2.csv etc. deleted as the scripts cleans up the directory after the simulation. Use the `ls Results_*` command to see the results. You should see something like the following in the directory of your simulation. 

```
[psh39@compt339 SD4DS_1-5]$ ls Results_*
Results_10.csv  Results_13.csv  Results_16.csv  Results_19.csv  Results_2.csv  Results_5.csv  Results_8.csv
Results_11.csv  Results_14.csv  Results_17.csv  Results_1.csv   Results_3.csv  Results_6.csv  Results_9.csv
Results_12.csv  Results_15.csv  Results_18.csv  Results_20.csv  Results_4.csv  Results_7.csv
```

Next, we are ready to start processing the results in R, but frist we need to load the R module. R modules are constantly being updated with older versions removed. To find the available module, we can use the `spider` command. 

```
module spider R
```

To load the R module, we use the `module load` command followed by the module name we want to load. Note that the specific version of R below should match what is available from the `module spider R` output above. If these don't match, load a more recent version of R.

```
module load R/4.1.2-foss-2021b
```

Once we have successfully loaded the R module, we can process the results using Rscript process_results.R by calling the Rscript command. 

```
Rscript process_results.R
```

If you now type the `ls` command to see the files in your directory, you'll notice that the temporary files Results_1.csv, Results_2.csv, etc. have been removed and the file study_results.RData has been created, which is an R binary data object with just the values we wanted to save. 

```
[psh39@compt339 SD4DS_1-5]$ ls
'limits to growth.stmx'   process_results.R   Results.csv   simulate_study1.slurm   study1.csv   study_results.RData
 Parms.csv                README.md           simulate.sh   simulate_study.awk      study2.csv
```

Last, exit the session on the compute node. 

```
exit
```

## 4. Running simulation study1 as a batch process

So far, we have only shown how to conduct a simulation study using Stella Simulator where the main benefit is having access to Stella Simulator. However, the real advantage of using the HPC comes from being able to set up and run multiple simulations as batch jobs on the HPC. For example, if a single simulation study takes ~2 hours on the HPC, one can submit a series of simulation studies that can all be running as resources become available versus having to run them sequentially on a desktop or laptop computer. 

Batch processing is managed be submitting a batch job with a SLURM script. The simulate_study.slurm script defines computing resources needed along with R modules to load. 

Before submitting the batch job, you'll need to modify the mail-user option to your email address so you can get the notifications of the job status, i.e., replace "<your email address>" with the email address where you want to receive notifcations about the job starting and finishing. For example, if your email address is abc123@case.edu, you would change the line from,

```
#SBATCH --mail-user=<your email address> 
```
to

```
#SBATCH --mail-user=abc123@case.edu. 
```

Once you have made this modification, submit study1 as a batch job, using the `sbatch` command.

```
sbatch simulate_study1.slurm
```

Unlike the previous examples, you will not see the actual results, but instead a notice that the job has been submitted. At this point, you can exit the session and the job will keep running until completed. 

```
Submitted batch job 2548367
```
Once completed, the simulate_study1.slurm script saves the results from timing the simulation to the file timing_study1.out. To see how long the script took, use the `cat timing_study1.out` to display the file with the results to the terminal.

```
[psh39@compt339 SD4DS_1-5]$ cat timing_study1.out
Study 1 Limits to Growth
real    0m16.627s
user    0m10.960s
sys     0m1.824s
```
There are three times provided: real, user, and sys. The real time is the actual time on the wall that it took to complete this job from begining to end (16.627 seconds). the user time is how much time was used to execute the program (10.960 seconds). And, the sys time is how much time it took for the operating system to support our program (1.824 seconds), which includes time used to access a disk, load a module, etc. Practically, we are most concerned with the overall real time since that is what we are working with and this is close to what is reported in the job completion email. 

## 5. On your own

Copy and modify the SLURM script to design and conduct a simulation study using the Limits to Growth.stmx model and study2.csv file. 

## 6. Some things to note

There are several things to pay attention to as you beyond this initial example. 

1. How you write your `process_results.R` script can have a significant on how long it takes to complete and process the simulation. Paying attention to the timing of the simulation models can help identify areas to improve the efficiency of your simulation studies (not only saving you time, but also energy and the carbon footprint of your simulation). For example, the base R function for reading a .csv file, read.csv() is significantly slower for large files than the readr library function read_csv(). See [Section 5.6](https://bookdown.org/csgillespie/efficientR/input-output.html) from Colin Gillespie and Robin Lovelace's *Efficient R programming*.

2. We ran all the simulations in the same director, but if we want to start more than one process at a time, we need to run each simulation in its own directory. Otherwise, we'll have a situation where two or more jobs are overwriting their simulation results.

3. We have not talked about how the study.csv file is constructed, but how we do that becomes important if we are to have meaningful interpretations of the results. For some studies, we might want to randomly sample values across a parameter space. For other studies, however, we'll want to define the runs in a way that the results are ordered. How we do this is an essential aspect of the design of a simulation study, which will be convered in a subsequent exercise. 



