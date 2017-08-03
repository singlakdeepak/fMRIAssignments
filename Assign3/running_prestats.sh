#!/bin/bash

OUTPUT=/Users/myhome/Desktop/Academics/Semester6/fMRICourse/Assignments
INPUT=/Users/myhome/Desktop/Academics/Semester6/fMRICourse/Assignments/Assign3/bold_task003
ANATOMY=/Users/myhome/Desktop/Academics/Semester6/fMRICourse/Assignments/Assign2/Assign2/sub001/anatomy/highres001_brain

\cp design_prestats.fsf design_prestats_enabled.fsf

sed -i -e 's_OUTPUTDIRECTORY_'$OUTPUT'_g' design_prestats_enabled.fsf
sed -i -e 's|INPUTDATA|'$INPUT'|g' design_prestats_enabled.fsf
sed -i -e 's|ANATOMYDATA|'$ANATOMY'|g' design_prestats_enabled.fsf
feat design_prestats_enabled.fsf

