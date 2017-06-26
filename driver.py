#!/usr/bin/env python
"""
 mpiexec -np $PBS_NP python jza.py|sort -n
"""

import sys

from mpi4py import MPI

from read_nc import read_nc


NUM_CUBE_FACES = 6

size = MPI.COMM_WORLD.Get_size()
rank = MPI.COMM_WORLD.Get_rank()
name = MPI.Get_processor_name()

sys.stdout.write(
    "Hello, World! I am process %d of %d on %s.\n"
    % (rank, size, name))

# Create a separate intracommunicator for each face
color = rank / (size / NUM_CUBE_FACES) # tasks closest to each other work on same face
color = min(color, NUM_CUBE_FACES-1) # any extra procs will go to last intracomm # TODO : Optimize
key = rank
cube_face_intracomm = MPI.COMM_WORLD.Split(color, key)

sys.stdout.write("My rank={0:02d}, color={1}, intracomm_size={2}\n"
                 .format(rank,color,cube_face_intracomm.size))

file_name = "grid_spec.tile6.nc"
read_nc(cube_face_intracomm.py2f(), file_name)

