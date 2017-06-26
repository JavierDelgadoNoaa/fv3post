#!/usr/bin/env sh

source /etc/profile.d/modules.sh # must preceed 'set -aeu'

module load intel/15.0.3.187
module load mvapich2/1.8
#module load  pnetcdf/1.5.0
echo "Not loading pnetcdf since -fPIC-compiled version may be needed"



