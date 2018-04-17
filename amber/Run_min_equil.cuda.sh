#!/bin/bash
#SBATCH -J PzYdEqu
#SBATCH --get-user-env
#SBATCH --partition=gpus
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --time=300:00:00
#SBATCH --mail-user=wmsmith@uci.edu

#set -e 

source /cm/shared/apps/amber16_cuda/amber.sh

set -e
toppath="step1_charmm2amber.parm7"

echo "running minimization"
prev_step="step1_charmm2amber"
step="step2_minimization"
$AMBERHOME/bin/pmemd.cuda  -O -i $step.mdin -c $prev_step.rst7 \
	-p $toppath -r $step.rst7 -ref $prev_step.rst7 \
	-o $step.out -x $step.nc

echo "running equil 01"
prev_step="step2_minimization"
step="step3_equilibration"
$AMBERHOME/bin/pmemd.cuda  -O -i $step.mdin -c $prev_step.rst7 \
	-p $toppath -r $step.rst7 -ref $prev_step.rst7 \
	-o $step.out -x $step.nc

