
#!/bin/bash

for run in _task002_80 
 do
 #Loops through all runs and replaces "ChangeMe" with run number

 \cp design_task002.fsf tmpDesign_task002.fsf
 sed -i -e 's/_task002/taskChange/g' tmpDesign_task002.fsf
# sed -i -e 's/FSL_01/FSL_ChangeMyRun/' tmpDesign.fsf #Replaces run placeholder with variable "ChangeMyRun"; this will be swapped later with the appropriate run number
 echo "File found; task file is " $run
 \cp tmpDesign_task002.fsf design_$run.fsf #Make a copy for each run
 sed -i -e 's/taskChange/'$run'/g' design_$run.fsf #Swap "ChangeMyRun" with run number
 \rm *-e #Remove excess schmutz
 \rm tmpDesign_task002.fsf
 feat design_$run.fsf #Run feat for each run
done
