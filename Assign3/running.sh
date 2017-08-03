
#!/bin/bash

for run in task001 task002 task003 
 do
 #Loops through all runs and replaces "ChangeMe" with run number

 \cp design.fsf tmpDesign.fsf
 sed -i -e 's/task001/taskChange/g' tmpDesign.fsf
# sed -i -e 's/FSL_01/FSL_ChangeMyRun/' tmpDesign.fsf #Replaces run placeholder with variable "ChangeMyRun"; this will be swapped later with the appropriate run number
 echo "File found; task file is " $run
 \cp tmpDesign.fsf design_$run.fsf #Make a copy for each run
 sed -i -e 's/taskChange/'$run'/g' design_$run.fsf #Swap "ChangeMyRun" with run number
 \rm *-e #Remove excess schmutz
 #feat design_$run.fsf #Run feat for each run
done
