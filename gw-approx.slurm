#!/bin/bash
#SBATCH --partition=h100          # GPU-partition
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=12:00:00
#SBATCH --output=out_gw.o%j
#SBATCH --error=err_gw.e%j  

module purge
module load gcc/13.2.0
module load eigen/3.4.0
module load openmpi/5.0.8
module load hdf5/1.14.3
module load python/3.12.11
#module load mkl/23.1
module load cmake/3.28.1
module load cuda/12.4

module list
ldd $HOME/green_gpu/green-mbpt-install/bin/mbpt.exe | grep mkl
nvidia_smi
hostname
echo "current directory" $(pwd)
echo "ls:" $(ls)
date

export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1
export HDF5_USE_FILE_LOCKING=FALSE
export PYSCF_MAX_MEMORY=100000

srun $HOME/green_gpu/green-mbpt-install/bin/mbpt.exe \
     --scf_type=GW \
     --BETA 100 \
     --grid_file ir/1e4.h5 \
     --itermax 20 \
     --results_file Si.h5 \
     --mixing_type CDIIS \
     --diis_start 2 \
     --diis_size 5 \
     --mixing_weight 0.3 \
     --high_symmetry_output_file Si_hs.h5 \
     --jobs SC,WINTER \
     --kernel GPU \
     --cuda_low_gpu_memory true \
     --cuda_low_cpu_memory true \
     --Sigma_sp=true \
     --P_sp=true \

echo "hello, world!"
echo "I want a different line!!"
echo "hello, world once more!"

date
