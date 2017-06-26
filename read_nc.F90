#define CHECK_PNC_CALL(f) if(ierr.ne.0) write(0,*) "error in call to ", f, ". exit code=", ierr; call flush(0)

subroutine read_nc(comm, file_name)
  use mpi
  use pnetcdf
  implicit none
  integer, intent(in) :: comm
  character(len=200) :: file_name
! input file and variabes
  character (len = *), parameter :: XDIM = "grid_x" !"grid_lat"
  character (len = *), parameter :: YDIM = "grid_y" !"grid_lat"
  character (len = *), parameter :: LON_NAME = "grid_lon" !"grid_lat"
  character (len = *), parameter :: LAT_NAME = "grid_lat" !"grid_lon"

! integer
  integer :: i,j,k
  integer :: ncid,imax,jmax,nfopen,nfxdim,nfydim,dimid,dimlen,varid
  integer :: ierr, nprocs, rank
  !MPI_Offset :: nrecs
  INTEGER(KIND=MPI_OFFSET_KIND) nlats, nlons

! real variables
  Real(4), Allocatable:: data1d (:)
  Real(4), Allocatable:: data2d (:,:)
  !Real(kind=FourByteReal) :: data2d(:,:)

! for indexing
  integer(kind=MPI_OFFSET_KIND) starts2d(2), counts2d(2), strides2d(2), imap2d(2)

! MPI init
!!call MPI_Init(ierr) ! passing in communicator,so shouldn't need this
call MPI_Comm_rank(comm, rank, ierr)
call MPI_Comm_size(comm, nprocs, ierr)

! open the file
  print *, "jza33 file = ", file_name
  ierr = nf90mpi_open(comm, file_name, nf_nowrite, MPI_INFO_NULL, ncid)
  CHECK_PNC_CALL("nf90mpi_open")

! Get xdim
  ierr = nf90mpi_inq_dimid (ncid, XDIM, dimid)
  CHECK_PNC_CALL("nf90mpi_inq_dimid")
  ierr = nf90mpi_inquire_dimension (ncid, dimid, len=nlons)
  CHECK_PNC_CALL("nf90mpi_inq_dimid")

! Get ydim
  ierr = nf90mpi_inq_dimid (ncid, YDIM, dimid)
  CHECK_PNC_CALL("nf90mpi_inq_dimid")
  ierr = nf90mpi_inquire_dimension (ncid, dimid, len=nlats)
  CHECK_PNC_CALL("nf90mpi_inquire_dimension")
  ierr = nf90mpi_inq_varid (ncid, YDIM, varid)
  CHECK_PNC_CALL("nf90mpi_inq_varid")
!
  write(0,*)'XDIM=',nlons,'YDIM=',nlats

! Get lat and lon values
  ierr = nf90mpi_inq_varid (ncid, LON_NAME, varid)
  CHECK_PNC_CALL("nf90mpi_inq_varid")
  !Allocate(data1d(nlons))
  Allocate(data2d(nlats, nlons))
  data1d(:) = 4. ! test
  data2d(:,:) = 5. ! test
  ! grid_lat is of dimensions (grid_y, grid_x)
  starts2d = (1,1)
  counts2d(1) = nlats
  counts2d(2) = nlons
  strides2d = 1
  ! independant - by default, open() will be in collective mode, so switch
  ! to independant mode if needed
  !!ierr = nf90mpi_begin_indep_data(ncid)
  !!CHECK_PNC_CALL
  !!ierr= nf90mpi_get_var (ncid, varid, data2d, start=starts2d, count=counts2d, stride=strides2d)
  !!CHECK_PNC_CALL
  !!
  ! collective
  ierr= nf90mpi_get_var_all (ncid, varid, data2d, start=starts2d, count=counts2d, stride=strides2d)
  CHECK_PNC_CALL("nf90mpi_get_var_all")
  !!
  !ierr= nf90mpi_get_var_double_all (ncid,varid,data1d) !jdelgado
  !ierr= nf90mpi_get_var_double (ncid,varid,data1d) !jdelgado

  write(0,*)LON_NAME,varid
  !write(0,*)(data1d(i),i=1,nlons)
  write(0,*)(data2d(1,i),i=1,nlons)

end subroutine read_nc
