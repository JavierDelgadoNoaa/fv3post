#!/usr/bin/env sh

source /etc/profile.d/modules.sh # must preceed 'set -aeu'
module load intel/15.1.133
module load impi/4.1.3.048
module load szip/2.1 hdf5/1.8.14 netcdf/4.3.0
#module load  pnetcdf/1.5.0-impi
echo "Not loading pnetcdf module since -fPIC-compiled version needed for f2py"

