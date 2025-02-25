#!/bin/bash

# We expect an output directory structure like that
# produced by SeisSol_ParamStudies:
# output_dir/
#         |_  0000/ (start number, usually 0000)
#               |_ 0000-surface.xdmf
#                  ...
#         ...
#            0099/ (end number, usually 0099 or 0009)
#               |_ 0099-surface.xdmf
#                  ...

# Path to directory with outputs
output_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/outputs_test_step3
# This script assumes that you installed SeisSol in ~/SeisSol/
#  please adjust the path in the postprocessing steps if necessary


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
#       Postprocessing Step 2: Generate visualization at end time #
#       ########################################################### #
#       This will create a file named $filenameprefix-surface-resampled.xdmf
        echo "Postprocessing Step 2: Generate visualization at end time"
        python ~/SeisSol/postprocessing/visualization/tools/extractDataFromUnstructuredOutput.py $myfile --Data u1 u2 u3 --time i-1
        cd ..; pwd
done
