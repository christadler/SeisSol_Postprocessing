#!/bin/bash

# We expect an output directory structure like that
# output_dir/
#         |_  0000/ (start number, usually 0000)
#               |_ 0000-surface.xdmf
#                  ...
#         ...
#            0099/ (end number, usually 0099 or 0009)
#               |_ 0099-surface.xdmf
#                  ...

# Path to directory with input and slurm files 
#input_dir=/hppfs/work/pn49ha/di35ban/AltoTiberina
# Path to directory with outputs
#output_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/outputs_10bigRuns
output_dir=/hppfs/scratch/0C/ra35zih2/AltoTiberina/outputs/
# Path to sdl directory
#sdl_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/sdl_10bigRuns_wSmallerFaultOutput
sdl_dir=/hppfs/scratch/0A/di35ban/AltoTiberina/sdl_100Runs
mkdir -pv $sdl_dir



# ############################################## #
#   Copy input data that should be saved         #
# ############################################## #
# The SDL wizard currently cannot handle the input data
#cd $input_dir; echo "input_dir: "; pwd
#mkdir -pv $sdl_dir/inputs
#for i in {0000..0009}; do
        ## Copy input parameter files
        #cp -r $i   $sdl_dir/inputs/
#done
## Copy slurm file + stdout + stderr
#cp *err    $sdl_dir/inputs/
#cp *out    $sdl_dir/inputs/
#cp *slurm  $sdl_dir/inputs/


# ############################################## #
#   Copy output data that should be saved        #
# ############################################## #
cd $output_dir; echo "output_dir: "; pwd
# Adjust start to end number accordingly 0000..0099 or 0000..0009
for i in {0000..0099}; do
        echo "ID: $i"
        cd $i; pwd
        mkdir -pv $sdl_dir/$i

        # Copy surface.xdmf
        myfile=$i-surface.xdmf
        echo "Myfile: $myfile"
        ls -al $myfile

        # We don't need $i-surface.xdmf or $i.xdmf
        # but maybe Nico's script still uses them? (30MB)
        cp $i-surface.xdmf $sdl_dir/$i

        echo "Copy receiver files"
        cp $i-receiver* $sdl_dir/$i

        echo "Copy ground motion parameter files"
        cp $i-GME-surface* $sdl_dir/$i

        echo "Copy final_displacement output"
        cp $i\_final\_displacement* $sdl_dir/$i

        # We don't store most .csv files: clustering/flops/miniSeisSol or threadPinning
        echo "Only copy energy.csv"
        cp $i-energy.csv $sdl_dir/$i
        
        echo "Copy fault information"
        # We need the fault information, however the directories 
        # fault_cell (11GB) and fault_vertex (25MB) are really big so 
        # we decided to keep only every 5th second
        cp $i\_1s-fault.xdmf $sdl_dir/$i
        cp $i\_1s-fault.h5 $sdl_dir/$i

        echo "cd .."
        cd ..; pwd
done

