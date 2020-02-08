!----------------------------------------------------------------------
!  Code = gets free parameters to conduct OI
!
!  Any question about this code to Kyunghwa Lee (K.Lee)
!
!  e-mail address: lkh1515@gmail.com 
!----------------------------------------------------------------------

!----------------------------------------------------------------------
use sortingFun  ! To call subroutine "heapSort"

implicit none

INTEGER i,j,ia,t,n_t,l
INTEGER yy,h,d,tt,m,n,p,q,n_NN
INTEGER inn,k,inn_n,inn_o
INTEGER NX,NY,NN,NA,NT,NL
INTEGER XX
INTEGER nMON
INTEGER mode
REAL UNDEF

PARAMETER (NX=204)
PARAMETER (NY=273)
PARAMETER (NN=NX*NY)
PARAMETER (NL=10000)
PARAMETER (UNDEF=-0.0009)

CHARACTER(400) input
CHARACTER(10) input_date
CHARACTER(9) input_Jul
!----------------------------------------------------------------------

!----------------------- variable declaration -------------------------  
REAL LON(NX,NY), LAT(NX,NY)
REAL LON_1D(NN), LAT_1D(NN)
REAL CMAQ(NX,NY), SFC(NX,NY)
REAL CMAQ_1D(NN), SFC_1D(NN), SFC_1D_mo(NN)
REAL SFC_woUNDEF(NN)
REAL MON_AE(NN), DAY_AE(NN), TIME_AE(NN)
REAL CMAQ_1D_A(NL), SFC_1D_A(NL), CH_NA_ORI_A(NL)
INTEGER AE_t
INTEGER temp

REAL xi2_f,fmb,f0b,emb,e0b
INTEGER imax
INTEGER hh
real ngrid,ngrid_ko
REAL rc,r
REAL dx,dy,lxy,lxy_ko
REAL fm,f0,em,e0

REAL O,B,KL
REAL oi_result(NL),oi_result_f(NL)
REAL com(NL,2)
INTEGER count1, count_0, count_m
REAL sum1, sum_0, sum_m
REAL gap_qm2(NL),xi1(NL)
REAL xi2
INTEGER k5
REAL results(5,NN)
CHARACTER(10) species
INTEGER nDATA,nALL,nDATA_NA

REAL dist(NX,NY,NL)
REAL tosort(NN)
REAL min_dist(NL)

REAL dist_n(NX,NY,NL)
REAL dist_n_f(NN,NL)
REAL tosort_n(NN)
REAL min_dist_n(NL)

REAL P_b(NY,NX), T_b(NY,NX)
REAL P_f(NX,NY), T_f(NX,NY)
REAL P_final(NL), T_final(NL)
REAL set_em, set_e0

REAL data_oi(NN), data_oi_2D(NX,NY), data_oi_2D_f(NY,NX)
REAL O_f,B_f,KL_f,O_f2,KL_f2
REAL fm_ref, f0_ref, em_ref, e0_ref
REAL eff_r_o,eff_r_o_ko
INTEGER z
INTEGER NZ
PARAMETER (em_ref=0.0)
PARAMETER (e0_ref=0.0)
PARAMETER (dx=15.)
PARAMETER (dy=15.)
PARAMETER (ngrid=7.)
PARAMETER (ngrid_ko=7.)
PARAMETER (lxy=dx*ngrid) !in km
PARAMETER (lxy_ko=dx*ngrid_ko) !in km
PARAMETER (NZ=20) !# of closest OBS points from model grid <- don't make it too many

REAL temp_rc
PARAMETER (temp_rc=1.0)
INTEGER temp_n

REAL dist_o(NN,NX,NY)
REAL tosort_o(NN)
REAL min_dist_o(NX,NY,NZ)
REAL min_dist_o_f(NN,NZ)

INTEGER temp_i,temp_j,nn_d
INTEGER nn_i(NN,NZ),nn_j(NN,NZ)
INTEGER num_SFC,num_SFC2
REAL sum_SFC,sum_SFC2
 
REAL temp_z(NZ)

CHARACTER(4) Ystep_DA_s
CHARACTER(2) Mstep_DA_s
CHARACTER(2) Dstep_DA_s
CHARACTER(2) Tstep_DA_s
CHARACTER(300) rearranged_WRF_PATH
CHARACTER(300) NAMIS_PATH
CHARACTER(300) NAMIS_ORI_PATH
CHARACTER(300) MOPITT_PATH
CHARACTER(300) GOME2B_PATH
CHARACTER(300) OMI_PATH
CHARACTER(300) GOCI_PATH
CHARACTER(300) AERONET_PATH
CHARACTER(300) DA_PATH_OUTPUT_F
CHARACTER(300) converted_CMAQ_PATH
CHARACTER(300) VAL_CHINA_NAMIS_noCollo
CHARACTER(300) RANDOM_CHINA_NAMIS_PATH
CHARACTER(300) SFC_DA_INPUT
CHARACTER(300) AERONET_ORI_PATH
CHARACTER(20) Tstep_num
CHARACTER(10) Tstep_s
INTEGER Tstep
CHARACTER(20) format_Tstep_num
REAL*4 species_max,species_min,CMAQ_max,SAT_max,SFC_max
CHARACTER(10) DA_SPECIES
CHARACTER(10) DA_SPECIES_f
CHARACTER(30) AERONET_SITE(NL)

CHARACTER(10) yymmddtt
CHARACTER(10) yymmddtt_temp
CHARACTER(20) input_CM
CHARACTER(7) JULIAN_DA_s
INTEGER JULIAN_DA
INTEGER Tstep_DA
INTEGER temp_num
INTEGER NZ_f
INTEGER nCH_NA
REAL CH_NA_LON(NL), CH_NA_LAT(NL), CH_NA_ORI(NL)
REAL max_ratio,species_max_AOD
PARAMETER (max_ratio=2.0)
PARAMETER (species_max_AOD=3.0)

input_CM='CMAQoutput_2014JULtt'
eff_r_o=ngrid
eff_r_o_ko=ngrid_ko

Call GET_ENVIRONMENT_VARIABLE("DA_SPECIES_f",DA_SPECIES_f)
species=trim(DA_SPECIES_f)

print*, species
!----------------------------------------------------------------------


!-------------------------------- read ---------------------------------
Call GET_ENVIRONMENT_VARIABLE("AERONET_PATH",AERONET_PATH)
input=''//trim(AERONET_PATH)//'/CMAQ_2016_LON.txt'
OPEN(711,FILE=input)
do i=1,NX
  read(711,*,end=1) (LON(i,j),j=1,NY)
enddo
1 close(711)
! print*, LON(3,3), LON(NX,NY), LON(NX,NY-1)

input=''//trim(AERONET_PATH)//'/CMAQ_2016_LAT.txt'
OPEN(712,FILE=input)
do i=1,NX
  read(712,*,end=2) (LAT(i,j),j=1,NY)
enddo
2 close(712)
! print*, LAT(3,3), LAT(NX,NY), LAT(NX,NY-1)
!----------------------------------------------------------------------

!------------------------------- process -------------------------------
Call GET_ENVIRONMENT_VARIABLE("JULIAN_DA",JULIAN_DA_s)
Call GET_ENVIRONMENT_VARIABLE("Ystep_DA",Ystep_DA_s)
Call GET_ENVIRONMENT_VARIABLE("Mstep_DA",Mstep_DA_s)
Call GET_ENVIRONMENT_VARIABLE("Dstep_DA",Dstep_DA_s)
Call GET_ENVIRONMENT_VARIABLE("Tstep_DA",Tstep_DA_s)
print*,JULIAN_DA_s
print*,Tstep_DA_s
read(JULIAN_DA_s,'(i7)') JULIAN_DA
read(Tstep_DA_s,'(i2)') Tstep_DA
write(yymmddtt,'(4A)') Ystep_DA_s,Mstep_DA_s,Dstep_DA_s,Tstep_DA_s
print*,yymmddtt

yymmddtt_temp=yymmddtt
if (Mstep_DA_s=="11") write(yymmddtt_temp,'(3A)') "201412",Dstep_DA_s,Tstep_DA_s
print*, yymmddtt_temp

Call GET_ENVIRONMENT_VARIABLE("OUTPUT_STEP",Tstep_num)
print*,trim(Tstep_num)

K5=1
! k5=k5+1

xi2_f=1
fmb=0
f0b=0
emb=0
e0b=0

n_t=0

write(input_CM(12:18),'(I7.7)'),JULIAN_DA
write(input_CM(19:20),'(I2.2)'),Tstep_DA
Call GET_ENVIRONMENT_VARIABLE("SFC_DA_INPUT",SFC_DA_INPUT)
input=SFC_DA_INPUT
print*,input
OPEN(713,FILE=input)
do i=1,NX
  read(713,*,end=3) (CMAQ(i,j),j=1,NY)
enddo
3 close(713)
! print*,CMAQ(3,3)

if (trim(species)=='AOD') then
  Call GET_ENVIRONMENT_VARIABLE("GOCI_PATH",GOCI_PATH)
  input=''//trim(GOCI_PATH)//'/collocated_GOCI_'//trim(species)//'_'//yymmddtt_temp//'.txt'
  print*,input
else
  Call GET_ENVIRONMENT_VARIABLE("RANDOM_CHINA_NAMIS_PATH",RANDOM_CHINA_NAMIS_PATH)
  input=''//trim(RANDOM_CHINA_NAMIS_PATH)//'/'//trim(species)//'/'//yymmddtt_temp// &
        '_CHINA+NAMIS_attached_removed_'//trim(species)//'.txt'
  print*,input
endif

OPEN(715,FILE=input)
do i=1,NX
  read(715,*,end=5) (SFC(i,j),j=1,NY)
enddo
5 close(715)
print*,SFC(44,154),SFC(44,156),SFC(155,45),SFC(150,167),SFC(153,170),SFC(170,153)

 SFC_max=MAXVAL(SFC)
 CMAQ_max=MAXVAL(CMAQ)

  if (trim(species)=='SO2') species_max=MAXVAL(SFC)
  if (trim(species)=='CO') species_max=MAXVAL(SFC)*max_ratio
  if (trim(species)=='NO2') species_max=MAXVAL(SFC)
  if (trim(species)=='O3') species_max=MAXVAL(SFC)
  if (trim(species)=='AOD') species_max=species_max_AOD
  if (trim(species)=='PM10') species_max=MAXVAL(SFC)*max_ratio

do i=1,NX
  do j=1,NY
    if (trim(species)=='AOD'  .and. CMAQ(i,j) > species_max) CMAQ(i,j)=species_max
    if (trim(species)=='PM10' .and. CMAQ(i,j) > species_max) CMAQ(i,j)=species_max
  end do !j
end do !i
species_min=MINVAL(SFC, MASK=SFC .gt. 0.0)*0.8
print*, 'max_OBS=',species_max
print*, 'min_OBS=',species_min

if (trim(species)=='AOD') then
  Call GET_ENVIRONMENT_VARIABLE("AERONET_ORI_PATH",AERONET_ORI_PATH)
  input=''//trim(AERONET_ORI_PATH)//'/rearranged_AERONET_'//trim(species)//'_'//yymmddtt_temp//'.txt'
  print*,input
  OPEN(720,FILE=input)
  n=0
  do i=1,NL
    read(720,*,end=10) AERONET_SITE(i), CH_NA_LON(i), CH_NA_LAT(i), CH_NA_ORI(i)
    nCH_NA=nCH_NA+1
  enddo
  10 close(720)
else
  Call GET_ENVIRONMENT_VARIABLE("VAL_CHINA_NAMIS_noCollo",VAL_CHINA_NAMIS_noCollo)
  input=''//trim(VAL_CHINA_NAMIS_noCollo)//'/'//trim(species)//'/'//yymmddtt_temp// &
        '_CHINA+NAMIS_chose_VAL_'//trim(species)//'.txt'
  print*,input
  OPEN(721,FILE=input)
  n=0
  do i=1,NL
    read(721,*,end=11) CH_NA_LON(i), CH_NA_LAT(i), CH_NA_ORI(i)
    nCH_NA=nCH_NA+1
  enddo
  11 close(721)
  ! print*,CH_NA_ORI
endif

if (species=="CO") then
  fm_ref=0.95
  f0_ref=0.05
elseif (species=="NO2") then
  fm_ref=0.95
  f0_ref=0.05
elseif (species=="SO2") then
  fm_ref=0.95
  f0_ref=0.05
elseif (species=="O3") then
  fm_ref=0.95
  f0_ref=0.05
elseif (species=="AOD") then
  fm_ref=0.8
  f0_ref=0.2
elseif (species=="PM10") then
  fm_ref=0.95
  f0_ref=0.05
endif
!----------------------------------------------------------------------

!------------------------ get free parameters -------------------------

if (species_max .gt. 0) then ! if SFC is available!
print*, 'SFC data is available!'
print*, 'max_OBS=',species_max
print*, 'min_OBS=',species_min

!### make all variables into 1D 
CMAQ_1D=UNDEF
SFC_1D=UNDEF
LON_1D=UNDEF
LAT_1D=UNDEF

XX=0
do i=1,NX
  do j=1,NY
    XX=XX+1
    CMAQ_1D(XX)=CMAQ(i,j)
    SFC_1D(XX)=SFC(i,j)
    LON_1D(XX)=LON(i,j)
    LAT_1D(XX)=LAT(i,j)
  enddo
enddo

!s&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
! find the observation closest to model grid
dist_o=9999.
do m=1,NX !model
  do n=1,NY  !model
    XX=0
    do i=1,NX !obs
      do j=1,NY !obs
        if (SFC(i,j) > 0.) then
        XX=XX+1
        temp_i=i
        temp_j=j
        dist_o(XX,m,n) = sqrt( (temp_i-m)**2. + (temp_j-n)**2. )
        endif
      enddo
    enddo
  enddo
enddo
print*,'XX1=',XX


do m=1,NX
  do n=1,NY
  tosort_o=0.0; inn_o=0
    do k=1,XX
      inn_o=inn_o+1
      tosort_o(inn_o)=dist_o(k,m,n)
    enddo

    call heapSort(tosort_o,inn_o)
    ! print*, tosort(1)
    do z=1,NZ
    min_dist_o(m,n,z)=tosort_o(z)
    enddo !z
  enddo
enddo

nn_d=0

do m=1,NX !model
  do n=1,NY  !model
  nn_d=nn_d+1
    XX=0

    do i=1,NX !obs
      do j=1,NY !obs
        if (SFC(i,j) > 0.) then
        XX=XX+1

          do z=1,NZ
          if (dist_o(XX,m,n)==min_dist_o(m,n,z)) then
             min_dist_o_f(nn_d,z)=min_dist_o(m,n,z)
             nn_i(nn_d,z)=i
             nn_j(nn_d,z)=j
          endif
          enddo !z
        endif
      enddo !j
    enddo !i
  enddo !n
enddo !m
print*,'XX2=',XX
print*,'nn_d=',nn_d
!e&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

rc=temp_rc
CMAQ_1D_A = UNDEF
SFC_1D_A = UNDEF

print*,'nCH_NA = ', nCH_NA
do ia=1,nCH_NA
  if (CH_NA_ORI(ia) .gt. 0.0) then
    do n_NN=1,NN
      r=sqrt((CH_NA_LAT(ia)-LAT_1D(n_NN))**2+(CH_NA_LON(ia)-LON_1D(n_NN))**2)
      if (r .le. rc) print*,ia,n_NN,CH_NA_ORI(ia),SFC_1D(n_NN),CMAQ_1D(n_NN)
      if (r .le. rc) then
        n_t=n_t+1
        rc=r
        hh=n_NN
          CMAQ_1D_A(n_t)  = CMAQ_1D(hh)
          SFC_1D_A(n_t) = SFC_1D(hh)
          CH_NA_ORI_A(n_t) = CH_NA_ORI(ia)
       endif
      enddo !n_NN
  endif
enddo !ia
print*, 'n_t', n_t
!-----------------------------------------------------------------------

!---------------- sensitivity test to get free parameters --------------
!### get free parameters 

imax=n_t

! set_em=minval(SFC_1D_A,SFC_1D_A .gt. 0)/100.
set_em=0.
set_e0=set_em
print*,set_em,set_e0

! find the free parameters $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$        
        count_0=0
        sum_0=0.
        count_m=0
        sum_m=0.
$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
do j=0,11
  f0=(j+1)*0.01
  do i=0,18
    fm=(i+1)*0.1
      do n=0,10

        if (trim(species)=='AOD') then
          e0=(n)*0.002 
        else
          e0=(n)*(species_min/1000.) 
        endif

      do m=0,10
        if (trim(species)=='AOD') then
          em=(m)*0.005 
        else
          em=(m)*(species_min/1000.)
        endif

          
        do p=1,imax 
        
        if (SFC_1D_A(p) .gt. 0) then
          O=(f0*SFC_1D_A(p))**2.+(e0)**2.
          B=((fm*CMAQ_1D_A(p))**2. + (em)**2.)*exp(-(dx**2.)/(2*lxy**2.))
! *exp(-(dx)/(2)/(lxy**2.))*exp(-(dy)/(2*lxy**2.))*exp(-(dx**2.+dy**2.)/(2*lxy**2.))
  
        KL=B/(O+B)
        print*,'KL = ', KL

        oi_result(p)=CMAQ_1D_A(p)+KL*(SFC_1D_A(p)-CMAQ_1D_A(p))

        com(p,1)=CH_NA_ORI_A(p)
        com(p,2)=oi_result(p)
        
        else
        com(p,1)=CH_NA_ORI_A(p)
        com(p,2)=UNDEF     
        endif
       
        enddo !p
        
        count1=0
        sum1=0.

        do q=1,imax 
        if ((com(q,2) .gt. 0.) .and. (com(q,1) .gt. 0.)) then
        gap_qm2(q)=(com(q,1)-com(q,2))**2.
        xi1(q)=gap_qm2(q)/com(q,2)
        count1=count1+1
        sum1=sum1+xi1(q)
        endif
        enddo
        print*,i,j,m,n,count1
        print*,i,j,m,n,sum1
        
        if (count1 .ne. 0.) then
          xi2=sum1/count1
          if(xi2 .lt. xi2_f) then
            xi2_f=xi2
            fmb=fm
            f0b=f0
            emb=em
            e0b=e0
            oi_result_f=oi_result
          endif
        endif
      enddo !m
    enddo !n
  enddo !j
enddo !i       


results(1,k5)=xi2_f
results(2,k5)=fmb
results(3,k5)=f0b
results(4,k5)=emb
results(5,k5)=e0b
Call GET_ENVIRONMENT_VARIABLE("DA_PATH_OUTPUT_F",DA_PATH_OUTPUT_F)
print*,trim(DA_PATH_OUTPUT_F)
input=''//trim(DA_PATH_OUTPUT_F)//'/'//trim(Tstep_num)//'_free_parameters_'&
//yymmddtt//'_'//trim(species)//'.txt'

OPEN (328,FILE=input) ! output file
write(328,"(7f20.10)") results(1,K5),results(2,K5),results(3,K5),&
results(4,K5),results(5,K5)
close(328)
!-----------------------------------------------------------------------

!---------------------------- conduct OI -------------------------------
  if (results(1,K5) .gt. 0 .and. results(1,K5) .lt. 1 ) then
    do n_NN=1,NN
        sum_SFC=0.
        num_SFC=0
        sum_SFC2=0.
        num_SFC2=0
        temp_num=0



        do z=1,NZ

  
!             B_f=((results(2,K5)*CMAQ_1D(n_NN))**2.+(results(4,K5))**2.)*exp(-(dx**2.+dy**2.)/(2*lxy**2.))
             B_f=((results(2,K5)*CMAQ_1D(n_NN))**2.+(results(4,K5))**2.)*exp(-(dx**2.)/(2*lxy**2.))

            if (min_dist_o_f(n_NN,z) <= eff_r_o) then

            temp_z(z)=SFC(nn_i(n_NN,z),nn_j(n_NN,z))
! ! !             temp_z(z)=SFC(nn_i(n_NN,z),nn_j(n_NN,z))/CMAQ(nn_i(n_NN,z),nn_j(n_NN,z))
            sum_SFC=sum_SFC+temp_z(z)
            num_SFC=num_SFC+1
            end if

        enddo !z

        SFC_1D_mo(n_NN)=sum_SFC/num_SFC
! ! !         SFC_1D_mo(n_NN)=sum_SFC/num_SFC*CMAQ_1D(n_NN)

        O_f=(results(3,K5)*SFC_1D_mo(n_NN))**2.+(results(5,K5))**2.

        KL_f=B_f/(O_f+B_f)

        if (isnan(SFC_1D_mo(n_NN))) SFC_1D_mo(n_NN)=CMAQ_1D(n_NN)
        data_oi(n_NN)=CMAQ_1D(n_NN)+KL_f*(SFC_1D_mo(n_NN)-CMAQ_1D(n_NN))
        print*,'lkh1=', KL_f

    enddo !n_NN
  else

    do n_NN=1,NN
s
        sum_SFC=0.
        num_SFC=0
        sum_SFC2=0.
        num_SFC2=0
        temp_num=0


        do z=1,NZ

             B_f=((fm_ref*CMAQ_1D(n_NN))**2.+(em_ref)**2.)*exp(-(dx**2.)/(2*lxy**2.))

            if (min_dist_o_f(n_NN,z) <= eff_r_o) then
            temp_z(z)=SFC(nn_i(n_NN,z),nn_j(n_NN,z))
            sum_SFC=sum_SFC+temp_z(z)
            num_SFC=num_SFC+1
            end if

        enddo !z
        SFC_1D_mo(n_NN)=sum_SFC/num_SFC

        O_f=(f0_ref*SFC_1D_mo(n_NN))**2.+(e0_ref)**2.

        KL_f=B_f/(O_f+B_f)
        print*,'lkh2=', KL_f

        if (isnan(SFC_1D_mo(n_NN))) SFC_1D_mo(n_NN)=CMAQ_1D(n_NN)
        data_oi(n_NN)=CMAQ_1D(n_NN)+KL_f*(SFC_1D_mo(n_NN)-CMAQ_1D(n_NN))


    enddo !n_NN
  endif

    do n_NN=1,NN
    ! This is to avoid having very small data (almost 0) for SO2
      if (data_oi(n_NN) < 0.00000001) data_oi(n_NN)=0.00000001

      if (trim(species)=='SO2'  .and. data_oi(n_NN) > species_max) data_oi(n_NN)=species_max
      if (trim(species)=='CO'   .and. data_oi(n_NN) > species_max) data_oi(n_NN)=species_max
      if (trim(species)=='NO2'  .and. data_oi(n_NN) > species_max) data_oi(n_NN)=species_max
      if (trim(species)=='O3'   .and. data_oi(n_NN) > species_max) data_oi(n_NN)=species_max
      if (trim(species)=='AOD'  .and. data_oi(n_NN) > species_max) data_oi(n_NN)=species_max
      if (trim(species)=='PM10' .and. data_oi(n_NN) > species_max) data_oi(n_NN)=species_max

      if (isnan(data_oi(n_NN))) data_oi(n_NN)=CMAQ_1D(n_NN)
      if (data_oi(n_NN) == 0.0) data_oi(n_NN)=0.00000001
    enddo !n_NN


    !### write output
    XX=0
    do i=1,NX
      do j=1,NY
        XX=XX+1
        data_oi_2D(i,j)=data_oi(XX)
        data_oi_2D_f(j,i)=data_oi_2D(i,j)
      enddo !j
    enddo !i
    OPEN (327,FILE=''//trim(DA_PATH_OUTPUT_F)//'/'//trim(Tstep_num)// &
               '_OBS+CMAQ_OI_'//trim(species)//'_'//yymmddtt//'_f.txt')
   
    do i=1,NX
        write(327,"(273f22.13)") (data_oi_2D(i,j),j=1,NY) 
    enddo
      close(327)

print*, 'e0_f=',e0
print*, 'em_f=',em

print*, 'influence radius of OBS to model grid for Korea=',eff_r_o_ko*15.,' km'
print*, 'influence radius of OBS to model grid for China=',eff_r_o*15.,' km'
print*, '# of closest OBS points from model grid=',NZ

else if (species_max .le. 0) then
    print*,'*** no SFC data for ',yymmddtt, ' ***'

    XX=0
    do i=1,NX
      do j=1,NY
        XX=XX+1
        CMAQ_1D(XX)=CMAQ(i,j)
      enddo
    enddo

    do n_NN=1,NN
      data_oi(n_NN)=CMAQ_1D(n_NN)
    end do !n_NN



    !### write output
    XX=0
    do i=1,NX
      do j=1,NY
        XX=XX+1
        data_oi_2D(i,j)=data_oi(XX)
        data_oi_2D_f(j,i)=data_oi_2D(i,j)
      enddo !j
    enddo !i
    print*,''//trim(DA_PATH_OUTPUT_F)//'/'//trim(Tstep_num)// &
               '_OBS+CMAQ_OI_'//trim(species)//'_'//yymmddtt//'_f.txt'
    OPEN (327,FILE=''//trim(DA_PATH_OUTPUT_F)//'/'//trim(Tstep_num)// &
               '_OBS+CMAQ_OI_'//trim(species)//'_'//yymmddtt//'_f.txt')
    do i=1,NX
        write(327,"(273f22.13)") (data_oi_2D(i,j),j=1,NY) 
    enddo
      close(327)

end if ! species_max

!-----------------------------------------------------------------------

STOP
END