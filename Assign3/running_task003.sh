
#!/bin/bash

for run in _task003_80 _task003_90 _task003_100 _task003_110 _task003_120
 do
 #Loops through all runs and replaces "ChangeMe" with run number

 \cp design_task003.fsf tmpDesign_task003.fsf
 sed -i -e 's/_task003/taskChange/g' tmpDesign_task003.fsf
# sed -i -e 's/FSL_01/FSL_ChangeMyRun/' tmpDesign.fsf #Replaces run placeholder with variable "ChangeMyRun"; this will be swapped later with the appropriate run number
 echo "File found; task file is " $run
 \cp tmpDesign_task003.fsf design_$run.fsf #Make a copy for each run
 sed -i -e 's/taskChange/'$run'/g' design_$run.fsf #Swap "ChangeMyRun" with run number
 \rm *-e #Remove excess schmutz
 \rm tmpDesign_task003.fsf
 feat design_$run.fsf #Run feat for each run
done
