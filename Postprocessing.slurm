#!/bin/bash
# Job Name and Files (also --job-name)
#SBATCH -J AltoTiberina_jobFarm
#SBATCH -o ./%j.%x.%N.out
#SBATCH -e ./%j.%x.%N.err

# Notification and type
#SBATCH --mail-type=ALL
#SBATCH --mail-user=marchandon@geophysik.uni-muenchen.de

# (Group) Account, (max) Wall clock and Queue:
#SBATCH --account=pn49ha
#SBATCH --time=00:30:00
#SBATCH --no-requeue
#SBATCH --partition=test

# Turn off energy aware runtime
#SBATCH --ear=off

# Setup of execution environment
#SBATCH --export=NONE
# Initial working directory (also --chdir)
#SBATCH -D ./

# Number of nodes and MPI tasks per node:
#SBATCH --nodes=16
#SBATCH --ntasks-per-node=1

module load slurm_setup

# Run the program:
export MP_SINGLE_THREAD=no
unset KMP_AFFINITY
export OMP_NUM_THREADS=94
export OMP_PLACES="cores(47)"

export XDMFWRITER_ALIGNMENT=8388608
export XDMFWRITER_BLOCK_SIZE=8388608
export SC_CHECKPOINT_ALIGNMENT=8388608

export SEISSOL_CHECKPOINT_ALIGNMENT=8388608
export SEISSOL_CHECKPOINT_DIRECT=1
export ASYNC_MODE=THREAD
export ASYNC_BUFFER_ALIGNMENT=8388608
export SEISSOL_ASAGI_MPI_MODE=OFF

source /etc/profile.d/modules.sh

echo 'num_nodes:' $SLURM_JOB_NUM_NODES 'ntasks:' $SLURM_NTASKS 'cpus_per_task:' $SLURM_CPUS_PER_TASK
ulimit -Ss 2097152

cd /hppfs/scratch/0C/ra35zih2/AltoTiberina/outputs; pwd

for i in {0000..0099}
do
        cd $i; pwd
        myfile=$i-surface.xdmf; ls -al $myfile
#       ########################################################### #
#       Postprocessing Step 1: Generate Ground Motion Parameters  #
#       ########################################################### #
        echo "Postprocessing Step 1: Generate Ground Motion Paramters"
        srun python -u ~/SeisSol/postprocessing/science/GroundMotionParametersMaps/ComputeGroundMotionParametersFromSurfaceOutput_Hybrid.py $myfile --MP 16

#       ########################################################### #
#       Postprocessing Step 2: Generate visualization at end time   #
#       ########################################################### #
#       This will create files named $filenameprefix_final_displacement-surface.xdmf/.h5
        #echo "Postprocessing Step 2: Generate visualization at "
        #seissol_output_extractor $myfile --var u1 u2 u3 --time "i-1" --add2prefix _final_displacement

#       ########################################################### #
#       Postprocessing Step 3: Shrink fault output (to every 5s)    #
#       ########################################################### #
        echo "Postprocessing Step 3: Shrink fault output (to every 5s)"
        seissol_output_extractor $i-fault.xdmf --var ASl Vr SRd SRs Sls Sld Pn0 Ts0 Td0 Mud PSR --time 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90  --add2prefix _5s

        cd ..; pwd
done


