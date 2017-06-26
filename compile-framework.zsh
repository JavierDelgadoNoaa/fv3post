#!/usr/bin/env zsh
#

set -x
where_am_i=`./util/where_am_i.py`
source conf/modules.${where_am_i}.sh
source conf/env.$where_am_i.sh
set -aeu

#eval mpif90 netread.f90 -o netread.x ${PNETCDF_INCLUDE} $PNETCDF_LD_OPTS
#
#eval f2py -m -c --f90exec=`which mpif90` read_nc  --include-paths ${PNETCDF_INCLUDE} netread.f90 $PNETCDF_LD_OPTS
#eval f2py -c --fcompiler=`which mpif90` --include-paths ${PNETCDF_INCLUDE} -m read_nc netread.f90 $PNETCDF_LD_OPTS

#f2py -c --fcompiler=`which mpif90` --include-paths /apps/pnetcdf/1.5.0-intel-mvapich2-1.8/include -L/apps/pnetcdf/1.5.0-intel-mvapich2-1.8/lib -lpnetcdf

#f2py -c --fcompiler=intelem --include-paths /apps/pnetcdf/1.5.0-intel-mvapich2-1.8/include -L/apps/pnetcdf/1.5.0-intel-mvapich2-1.8/lib -lpnetcdf

#f2py -c --f90exec=`which mpif90` --include-paths /apps/pnetcdf/1.5.0-intel-mvapich2-1.8/include netread.f90 -L/apps/pnetcdf/1.5.0-intel-mvapich2-1.8/lib -lpnetcdf

#f2py -c --f90exec=`which mpif90` -I/apps/pnetcdf/1.5.0-intel-mvapich2-1.8/include -L/apps/pnetcdf/1.5.0-intel-mvapich2-1.8/lib -lpnetcdf netread.f90
#eval f2py -c --f90exec=`which mpif90` $PNETCDF_INCLUDE $PNETCDF_LD_OPTS read_nc.f90

PNETCDF_INCLUDE="-I$PNETCDF/include"
PNETCDF_LD_OPTS="-L$PNETCDF/lib -lpnetcdf"
/lib/cpp -P read_nc.F90 > read_nc.f90
eval f2py -c --f90exec=`which ${F90_MPI_COMPILER}` $PNETCDF_INCLUDE $PNETCDF_LD_OPTS read_nc.f90 -m read_nc
