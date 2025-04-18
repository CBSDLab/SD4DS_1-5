# Read in the Results.csv file exported from Stella Simulator
# and create/append to the study.rds file

library(readr)

# setup
options(echo=FALSE)
run <- -1 # sets the run number to -1 to indicate an error

# read arguments
args <- commandArgs(trailingOnly = TRUE)
i <- length(args)
if(i>0) {
  for (j in 1:i) {
    eval(str2expression(args[j]))
  }
} else {
  print("No run number specified!")
}

# read in results from current simulation
library(readr)
Results <- read_csv("Results.csv")

# process results
tmp <- data.frame(Run=run,
                  Years=Results$Years,
                  Population=Results$Population)

# save results by creating/appending to study .csv file
if(run==1) {
  write_csv(tmp, file="study_results.csv", col_names = TRUE) 
  } else {
  write_csv(tmp, file="study_results.csv", append = TRUE)
  }



