#!/bin/bash

# We expect an output directory structure like that
# produced by SeisSol_ParamStudies:
# output_dir/
#         |_  0000/ (start number, usually 0000)
#               |_ 0000-surface.xdmf
#                  ...
#         ...
#          |_ 0009/ (end number, usually 0099 or 0009)
#               |_ 0009-surface.xdmf
#                  ...

# This script assumes that you installed SeisSol in ~/SeisSol/
#  please adjust the path in the postprocessing steps if necessary
# Path to directory with outputs
# output_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/outputs_test_step3
# output_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/outputs
output_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/outputs_10bigRuns

# ############################################## #
#            Postprocessing                      #
# ############################################## #
cd $output_dir; pwd
# Adjust start to end number accordingly 0000..0099 or 0000..0009
for i in {0000..0009}; do
        cd $i; pwd
        myfile=$i-surface.xdmf; ls -al $myfile
#       ########################################################### #
#         Postprocessing Step 1: Generate Ground Motion Parameters  #
#       ########################################################### #
        echo "Postprocessing Step 1: Generate Ground Motion Paramters"
        python -u ~/SeisSol/postprocessing/science/GroundMotionParametersMaps/ComputeGroundMotionParametersFromSurfaceOutput_Hybrid.py $myfile --MP 8

#       ########################################################### #
#       Postprocessing Step 2: Generate visualization at end time   #
#       ########################################################### #
#       This will create files named $filenameprefix_final_displacement-surface.xdmf/.h5
        echo "Postprocessing Step 2: Generate visualization at "
        seissol_output_extractor $myfile --var u1 u2 u3 --time "i-1" --add2prefix _final_displacement

#       ########################################################### #
#       Postprocessing Step 3: Shrink fault output (to every 5s)    #
#       ########################################################### #
        echo "Postprocessing Step 3: Shrink fault output (to every 5s)"
        seissol_output_extractor $i-fault.xdmf --var ASl Vr SRd SRs Sls Sld Pn0 Ts0 Td0 Mud PSR --time 0,5,10,15,20,25,30,35,40,45,50,55,60,65,70,75,80,85,90 --add2prefix _5s

        cd ..; pwd
done
