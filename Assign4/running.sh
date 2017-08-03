
#!/bin/bash
# _3_104pf__80 _3_104pf__100 _3_104pf__120 _4_104pf__80 _4_104pf__100 _4_104pf__120 _5_104pf__80 _5_104pf__100 _6_104pf__100 _7_104pf__100 _5_104pf__120 _6_104pf__80 _6_104pf__120 _7_104pf__80  _7_104pf__120  _8hpf_80 _8hpf_120
OUTPUTDIRECTORY=/Users/myhome/Desktop/Academics/Semester6/fMRICourse/Assignments/Assign4/Fin_solutiontakingAverageCHANGEME
INPUTDIR=/Users/myhome/Desktop/Academics/Semester6/fMRICourse/Assignments/Assign4/filtered_func_data_smoothCHANGEME
for run in _7_104pf__80 _7_104pf__120 _8hpf_80 _8hpf_120
#_5_104pf__80 _5_104pf__120 _6_104pf__80 _6_104pf__120
 do
 #Loops through all runs and replaces "ChangeMe" with run number


# either take design_fintkAvg.fsf or design_fin.fsf


 \cp design_fintkAvg.fsf tmpDesigntkAvg.fsf 

 sed -i -e 's|OUTPUTDIRECT|'$OUTPUTDIRECTORY'|g' tmpDesigntkAvg.fsf
 sed -i -e 's|INPUTDIRECTORY|'$INPUTDIR'|g' tmpDesigntkAvg.fsf
 
# sed -i -e 's/FSL_01/FSL_ChangeMyRun/' tmpDesign.fsf #Replaces run placeholder with variable "ChangeMyRun"; this will be swapped later with the appropriate run number
 echo "File found; task file is " $run
 \cp tmpDesigntkAvg.fsf designtkAvg$run.fsf #Make a copy for each run
 sed -i -e 's/CHANGEME/'$run'/g' designtkAvg$run.fsf #Swap "ChangeMyRun" with run number
 \rm *-e #Remove excess schmutz
 \rm tmpDesigntkAvg.fsf
 feat designtkAvg$run.fsf #Run feat for each run
done
