
#!/bin/bash

for run in _task001_80 _task001_90 _task001_100 _task001_110 _task001_120 
 do
 #Loops through all runs and replaces "ChangeMe" with run number

 \cp design_task001.fsf tmpDesign_task001.fsf
 sed -i -e 's/_task001/taskChange/g' tmpDesign_task001.fsf
# sed -i -e 's/FSL_01/FSL_ChangeMyRun/' tmpDesign.fsf #Replaces run placeholder with variable "ChangeMyRun"; this will be swapped later with the appropriate run number
 echo "File found; task file is " $run
 \cp tmpDesign_task001.fsf design_$run.fsf #Make a copy for each run
 sed -i -e 's/taskChange/'$run'/g' design_$run.fsf #Swap "ChangeMyRun" with run number
 \rm *-e #Remove excess schmutz
 \rm tmpDesign_task001.fsf
 feat design_$run.fsf #Run feat for each run
done
