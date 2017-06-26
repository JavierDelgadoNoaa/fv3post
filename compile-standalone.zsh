#!/usr/bin/env zsh
#

source /etc/profile.d/modules.sh # must preceed 'set -aeu'
set -aeu 
module load intel/15.1.133   
module load impi/4.1.3.048
module load szip/2.1 hdf5/1.8.14 netcdf/4.3.0   
module load  pnetcdf/1.5.0-impi

#eval mpiifort netread.f90 -o netread.x ${PNETCDF_INCLUDE} ${PNETCDF_LIB} -lnetcdff -lnetcdf

#eval mpiifort netread.F90 -o netread.x ${PNETCDF_INCLUDE} $PNETCDF_LD_OPTS 
/lib/cpp -P netread.F90 > netread.f90
eval mpiifort netread.f90 -o netread.x ${PNETCDF_INCLUDE} $PNETCDF_LD_OPTS 

