;*** information of this code ***********************************************
; This code is created by Kyunghwa Lee (K.Lee)
;
; e-mail address: lkh1515@gmail.com ;****************************************************************************

begin
;*** setting ****************************************************************
  setfileoption("nc", "Format", "LargeFile")
  AV_CONST = 6.0221415*10^23  ; Avogadro # (#/mol)
  R_CONST = 8.314472*10^6  ; Ideal Gas Constant (cm^3 P/K mol)
  AV_R = AV_CONST / R_CONST
  DU_R = 2.69*10^16  ; 1DU = 2.69*10^16 (#/cm2) 
  CMAQ_LAYER = 27


  WASO = (/"ASO4I", "ANH4I", "ANO3I", "ASO4J", "ANH4J", "ANO3J", "ACLI"/)
  WASO_K = (/"ANO3K", "ANH4K", "ASO4K"/)
  OM = (/"AALK1J", "AALK2J", "AXYL1J", "AXYL2J", "AXYL3J", "ATOL1J", "ATOL2J", "ATOL3J", \
    "ABNZ1J", "ABNZ2J", "ABNZ3J", "ATRP1J", "ATRP2J", "AISO1J", "AISO2J", \
    "AISO3J", "ASQTJ", "AORGCJ", "APOCJ", "APOCI", "AOLGAJ", "AOLGBJ", \
    "APNCOMJ", "APNCOMI", "APAH1J", "APAH2J", "APAH3J", "AOTHRJ"/)
  DUST_J = (/ "AFEJ", "AALJ", "ASIJ", "ATIJ", "ACAJ", "AMGJ", "AKJ", \
    "AMNJ"/)
  DUST_K = (/"ACORS", "ASOIL"/)
  EC = (/"AECI", "AECJ"/)
  SSA = (/"ANAJ", "ACLJ"/)
  SSC = (/"ACLK", "ASEACAT"/)

  DA_SPECIES = getenv("DA_SPECIES_f")
  print(DA_SPECIES)

  MCIP_DATA_PATH = getenv("MCIP_DATA_PATH")
  print(MCIP_DATA_PATH)

  yyyy = getenv("Ystep_DA")
  mm   = getenv("Mstep_DA")
  dd   = getenv("Dstep_DA")
  tt   = getenv("Tstep_DA")

  START_DAY  = stringtointeger(getenv("sJULIAN"))
  START_HOUR = stringtointeger(getenv("sHOUR"))
  END_DAY=stringtointeger(getenv("JULIAN_DA"))
  END_HOUR=stringtointeger(getenv("Tstep_DA"))

  n_layers = 27
  max_ratio = 1.3
  max_ratio_CO = 2.0
  max_AOD = 3.0
;****************************************************************************

;*** input file path & name *************************************************
  ;#read input
  nx=273
  ny=204
  nz=27
  ;nt=7
  nt=24

  nsize=nx*ny
  Tstep_num=getenv("OUTPUT_STEP")
  folder_name=getenv("folder_name")

  DA_PATH_OUTPUT = getenv("DA_PATH_OUTPUT")
  DA_FINAL_INPUT = getenv("DA_FINAL_INPUT")

  if (DA_SPECIES .eq. "AOD") then
;    input_file = DA_PATH_OUTPUT+"/"+Tstep_num+"_GOCI+CMAQ_OI_"+DA_SPECIES+"_"+yyyy+mm+dd+tt+"_f.txt"
    input_file = DA_FINAL_INPUT
    GOCI_PATH=getenv("GOCI_PATH")
  else if (DA_SPECIES .eq. "CO") then
    input_file = DA_FINAL_INPUT
  else if (DA_SPECIES .eq. "NO2") then
    input_file = DA_FINAL_INPUT
  else if (DA_SPECIES .eq. "SO2") then
    input_file = DA_FINAL_INPUT
  else if (DA_SPECIES .eq. "O3") then
    input_file = DA_FINAL_INPUT
  else if (DA_SPECIES .eq. "PM10") then
    input_file = DA_FINAL_INPUT
  end if
  end if
  end if
  end if
  end if
  end if

  print(input_file)
  OI=asciiread(input_file,(/ny,nx/),"float")

  Tstep_num=getenv("OUTPUT_STEP")
  APPL_NAME=getenv("APPL_NAME")
  CFG_NAME=getenv("CFG_NAME")
  sYEAR_s=getenv("sYEAR")
  sMON_s=getenv("sMON")
  sDAY_s=getenv("sDAY")
  DA_TIME=stringtointeger(getenv("DA_TIME"))
  print(DA_TIME)
  CMAQ_OUTPUT_PATH=getenv("CMAQ_OUTPUT_PATH")
  compiler=getenv("compiler") 

  input_file2=""+CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
               +"_"+sYEAR_s+sMON_s+sDAY_s+".nc"
  print(input_file2)
  CCTM = addfile(input_file2,"r")


  AODPM_DATA=CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
             +"_"+sYEAR_s+sMON_s+sDAY_s+"_AOD_PM.nc"
  print(AODPM_DATA)
  AODPM=addfile(AODPM_DATA, "r")


  if (DA_SPECIES .eq. "O3") then
    O3 = CCTM->O3
    before_adjust = O3
  else if (DA_SPECIES .eq. "CO") then
    CO = CCTM->CO
    before_adjust = CO
  else if (DA_SPECIES .eq. "SO2") then 
    SO2 = CCTM->SO2
    before_adjust = SO2
  else if (DA_SPECIES .eq. "NO2") then
    NO2 = CCTM->NO2
    before_adjust = NO2
  else if (DA_SPECIES .eq. "AOD") then
    AOD = AODPM->AOD
    before_adjust = AOD

   ;### WASO ###_________
    ASO4J=CCTM->ASO4J
    ASO4I=CCTM->ASO4I
    ANO3J=CCTM->ANO3J
    ANO3I=CCTM->ANO3I
    ANH4J=CCTM->ANH4J
    ANH4I=CCTM->ANH4I
    ACLI=CCTM->ACLI
    ANO3K=CCTM->ANO3K
    ANH4K=CCTM->ANH4K
    ASO4K=CCTM->ASO4K

   ;### EC ###_________
    AECJ=CCTM->AECJ
    AECI=CCTM->AECI

   ;### OM ###_________
    AALK1J=CCTM->AALK1J
    AALK2J=CCTM->AALK2J
    ABNZ1J=CCTM->ABNZ1J
    ABNZ2J=CCTM->ABNZ2J
    ABNZ3J=CCTM->ABNZ3J
    ATOL1J=CCTM->ATOL1J
    ATOL2J=CCTM->ATOL2J
    ATOL3J=CCTM->ATOL3J
    AXYL1J=CCTM->AXYL1J
    AXYL2J=CCTM->AXYL2J
    AXYL3J=CCTM->AXYL3J
    AOLGAJ=CCTM->AOLGAJ
    AISO1J=CCTM->AISO1J
    AISO2J=CCTM->AISO2J
    AISO3J=CCTM->AISO3J
    ATRP1J=CCTM->ATRP1J
    ATRP2J=CCTM->ATRP2J
    ASQTJ=CCTM->ASQTJ
    AOLGBJ=CCTM->AOLGBJ
    AORGCJ=CCTM->AORGCJ
    APOCI=CCTM->APOCI
    APOCJ=CCTM->APOCJ
    APNCOMI=CCTM->APNCOMI
    APNCOMJ=CCTM->APNCOMJ
    APAH1J=CCTM->APAH1J
    APAH2J=CCTM->APAH2J
    APAH3J=CCTM->APAH3J
    AOTHRJ=CCTM->AOTHRJ

   ;### SSA ###_________
    ANAJ=CCTM->ANAJ
    ACLJ=CCTM->ACLJ

   ;### SSC ###_________
    ASEACAT=CCTM->ASEACAT
    ACLK=CCTM->ACLK

   ;### DUST_J ###_________
    AALJ=CCTM->AALJ
    ACAJ=CCTM->ACAJ
    AFEJ=CCTM->AFEJ
    ASIJ=CCTM->ASIJ
    ATIJ=CCTM->ATIJ
    AMGJ=CCTM->AMGJ
    AKJ=CCTM->AKJ
    AMNJ=CCTM->AMNJ


   ;### DUST_K ###_________
    ACORS=CCTM->ACORS
    ASOIL=CCTM->ASOIL


    adjusted_ASO4J = new((/n_layers, ny, nx/), "float")
    adjusted_ASO4I = new((/n_layers, ny, nx/), "float")
    adjusted_ANO3J = new((/n_layers, ny, nx/), "float")
    adjusted_ANO3I = new((/n_layers, ny, nx/), "float")
    adjusted_ANH4J = new((/n_layers, ny, nx/), "float")
    adjusted_ANH4I = new((/n_layers, ny, nx/), "float")
    adjusted_ANH4K = new((/n_layers, ny, nx/), "float")
    adjusted_ANO3K = new((/n_layers, ny, nx/), "float")
    adjusted_AECJ = new((/n_layers, ny, nx/), "float")
    adjusted_AECI = new((/n_layers, ny, nx/), "float")
    adjusted_AALK1J = new((/n_layers, ny, nx/), "float")
    adjusted_AALK2J = new((/n_layers, ny, nx/), "float")
    adjusted_ABNZ1J = new((/n_layers, ny, nx/), "float")
    adjusted_ABNZ2J = new((/n_layers, ny, nx/), "float")
    adjusted_ABNZ3J = new((/n_layers, ny, nx/), "float")
    adjusted_ATOL1J = new((/n_layers, ny, nx/), "float")
    adjusted_ATOL2J = new((/n_layers, ny, nx/), "float")
    adjusted_ATOL3J = new((/n_layers, ny, nx/), "float")
    adjusted_AXYL1J = new((/n_layers, ny, nx/), "float")
    adjusted_AXYL2J = new((/n_layers, ny, nx/), "float")
    adjusted_AXYL3J = new((/n_layers, ny, nx/), "float")
    adjusted_APAH1J = new((/n_layers, ny, nx/), "float")
    adjusted_APAH2J = new((/n_layers, ny, nx/), "float")
    adjusted_APAH3J = new((/n_layers, ny, nx/), "float")
    adjusted_AOLGAJ = new((/n_layers, ny, nx/), "float")
    adjusted_AISO1J = new((/n_layers, ny, nx/), "float")
    adjusted_AISO2J = new((/n_layers, ny, nx/), "float")
    adjusted_AISO3J = new((/n_layers, ny, nx/), "float")
    adjusted_ATRP1J = new((/n_layers, ny, nx/), "float")
    adjusted_ATRP2J = new((/n_layers, ny, nx/), "float")
    adjusted_ASQTJ = new((/n_layers, ny, nx/), "float")
    adjusted_AOLGBJ = new((/n_layers, ny, nx/), "float")
    adjusted_AORGCJ = new((/n_layers, ny, nx/), "float")
    adjusted_APOCI = new((/n_layers, ny, nx/), "float")
    adjusted_APOCJ = new((/n_layers, ny, nx/), "float")
    adjusted_ANAJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACLJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACLI = new((/n_layers, ny, nx/), "float")
    adjusted_ASEACAT = new((/n_layers, ny, nx/), "float")
    adjusted_ACLK = new((/n_layers, ny, nx/), "float")
    adjusted_ASO4K = new((/n_layers, ny, nx/), "float")
    adjusted_APNCOMI = new((/n_layers, ny, nx/), "float")
    adjusted_APNCOMJ = new((/n_layers, ny, nx/), "float")
    adjusted_AOTHRJ = new((/n_layers, ny, nx/), "float")
    adjusted_AALJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACAJ = new((/n_layers, ny, nx/), "float")
    adjusted_AFEJ = new((/n_layers, ny, nx/), "float")
    adjusted_ASIJ = new((/n_layers, ny, nx/), "float")
    adjusted_ATIJ = new((/n_layers, ny, nx/), "float")
    adjusted_AMGJ = new((/n_layers, ny, nx/), "float")
    adjusted_AKJ = new((/n_layers, ny, nx/), "float")
    adjusted_AMNJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACORS = new((/n_layers, ny, nx/), "float")
    adjusted_ASOIL = new((/n_layers, ny, nx/), "float")
    adjusted_AOD = new((/ny, nx/), "float")

  else if (DA_SPECIES .eq. "PM10") then
    PM10 = AODPM->PM10
    before_adjust = PM10

   ;### EC ###_________
    AECJ=CCTM->AECJ
    AECI=CCTM->AECI

   ;### OM ###_________
    AALK1J=CCTM->AALK1J
    AALK2J=CCTM->AALK2J
    ABNZ1J=CCTM->ABNZ1J
    ABNZ2J=CCTM->ABNZ2J
    ABNZ3J=CCTM->ABNZ3J
    ATOL1J=CCTM->ATOL1J
    ATOL2J=CCTM->ATOL2J
    ATOL3J=CCTM->ATOL3J
    AXYL1J=CCTM->AXYL1J
    AXYL2J=CCTM->AXYL2J
    AXYL3J=CCTM->AXYL3J
    AOLGAJ=CCTM->AOLGAJ
    AISO1J=CCTM->AISO1J
    AISO2J=CCTM->AISO2J
    AISO3J=CCTM->AISO3J
    ATRP1J=CCTM->ATRP1J
    ATRP2J=CCTM->ATRP2J
    ASQTJ=CCTM->ASQTJ
    AOLGBJ=CCTM->AOLGBJ
    AORGCJ=CCTM->AORGCJ
    APOCI=CCTM->APOCI
    APOCJ=CCTM->APOCJ
    APNCOMI=CCTM->APNCOMI
    APNCOMJ=CCTM->APNCOMJ
    APAH1J=CCTM->APAH1J
    APAH2J=CCTM->APAH2J
    APAH3J=CCTM->APAH3J
    AOTHRJ=CCTM->AOTHRJ

   ;### SSA ###_________
    ANAJ=CCTM->ANAJ
    ACLJ=CCTM->ACLJ

   ;### SSC ###_________
    ASEACAT=CCTM->ASEACAT
    ACLK=CCTM->ACLK

   ;### DUST_J ###_________
    AALJ=CCTM->AALJ
    ACAJ=CCTM->ACAJ
    AFEJ=CCTM->AFEJ
    ASIJ=CCTM->ASIJ
    ATIJ=CCTM->ATIJ
    AMGJ=CCTM->AMGJ
    AKJ=CCTM->AKJ
    AMNJ=CCTM->AMNJ


   ;### DUST_K ###_________
    ACORS=CCTM->ACORS
    ASOIL=CCTM->ASOIL

    adjusted_AECJ = new((/n_layers, ny, nx/), "float")
    adjusted_AECI = new((/n_layers, ny, nx/), "float")
    adjusted_AALK1J = new((/n_layers, ny, nx/), "float")
    adjusted_AALK2J = new((/n_layers, ny, nx/), "float")
    adjusted_ABNZ1J = new((/n_layers, ny, nx/), "float")
    adjusted_ABNZ2J = new((/n_layers, ny, nx/), "float")
    adjusted_ABNZ3J = new((/n_layers, ny, nx/), "float")
    adjusted_ATOL1J = new((/n_layers, ny, nx/), "float")
    adjusted_ATOL2J = new((/n_layers, ny, nx/), "float")
    adjusted_ATOL3J = new((/n_layers, ny, nx/), "float")
    adjusted_AXYL1J = new((/n_layers, ny, nx/), "float")
    adjusted_AXYL2J = new((/n_layers, ny, nx/), "float")
    adjusted_AXYL3J = new((/n_layers, ny, nx/), "float")
    adjusted_APAH1J = new((/n_layers, ny, nx/), "float")
    adjusted_APAH2J = new((/n_layers, ny, nx/), "float")
    adjusted_APAH3J = new((/n_layers, ny, nx/), "float")
    adjusted_AOLGAJ = new((/n_layers, ny, nx/), "float")
    adjusted_AISO1J = new((/n_layers, ny, nx/), "float")
    adjusted_AISO2J = new((/n_layers, ny, nx/), "float")
    adjusted_AISO3J = new((/n_layers, ny, nx/), "float")
    adjusted_ATRP1J = new((/n_layers, ny, nx/), "float")
    adjusted_ATRP2J = new((/n_layers, ny, nx/), "float")
    adjusted_ASQTJ = new((/n_layers, ny, nx/), "float")
    adjusted_AOLGBJ = new((/n_layers, ny, nx/), "float")
    adjusted_AORGCJ = new((/n_layers, ny, nx/), "float")
    adjusted_APOCI = new((/n_layers, ny, nx/), "float")
    adjusted_APOCJ = new((/n_layers, ny, nx/), "float")
    adjusted_ANAJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACLJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACLI = new((/n_layers, ny, nx/), "float")
    adjusted_ASEACAT = new((/n_layers, ny, nx/), "float")
    adjusted_ACLK = new((/n_layers, ny, nx/), "float")
    adjusted_APNCOMI = new((/n_layers, ny, nx/), "float")
    adjusted_APNCOMJ = new((/n_layers, ny, nx/), "float")
    adjusted_AOTHRJ = new((/n_layers, ny, nx/), "float")
    adjusted_AALJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACAJ = new((/n_layers, ny, nx/), "float")
    adjusted_AFEJ = new((/n_layers, ny, nx/), "float")
    adjusted_ASIJ = new((/n_layers, ny, nx/), "float")
    adjusted_ATIJ = new((/n_layers, ny, nx/), "float")
    adjusted_AMGJ = new((/n_layers, ny, nx/), "float")
    adjusted_AKJ = new((/n_layers, ny, nx/), "float")
    adjusted_AMNJ = new((/n_layers, ny, nx/), "float")
    adjusted_ACORS = new((/n_layers, ny, nx/), "float")
    adjusted_ASOIL = new((/n_layers, ny, nx/), "float")
    adjusted_PM10 = new((/ny, nx/), "float")

  end if
  end if
  end if
  end if
  end if
  end if


  adjusted_value = new((/n_layers, ny, nx/), "float")

  RANDOM_CHINA_NAMIS_PATH = getenv("RANDOM_CHINA_NAMIS_PATH")

  if (DA_SPECIES .eq. "AOD") then
    input_OBS = GOCI_PATH+"/collocated_GOCI_AOD_" \
                +yyyy+mm+dd+tt+".txt"
  else if (DA_SPECIES .eq. "CO") then
    input_OBS = RANDOM_CHINA_NAMIS_PATH+"/"+DA_SPECIES+"/"+yyyy+mm+dd+tt+"_CHINA+NAMIS_attached_removed_" \
                +DA_SPECIES+".txt"
  else if (DA_SPECIES .eq. "NO2") then
    input_OBS = RANDOM_CHINA_NAMIS_PATH+"/"+DA_SPECIES+"/"+yyyy+mm+dd+tt+"_CHINA+NAMIS_attached_removed_" \
                +DA_SPECIES+".txt"
  else if (DA_SPECIES .eq. "SO2") then
    input_OBS = RANDOM_CHINA_NAMIS_PATH+"/"+DA_SPECIES+"/"+yyyy+mm+dd+tt+"_CHINA+NAMIS_attached_removed_" \
                +DA_SPECIES+".txt"
  else if (DA_SPECIES .eq. "O3") then
    input_OBS = RANDOM_CHINA_NAMIS_PATH+"/"+DA_SPECIES+"/"+yyyy+mm+dd+tt+"_CHINA+NAMIS_attached_removed_" \
                +DA_SPECIES+".txt"
  else if (DA_SPECIES .eq. "PM10") then
    input_OBS = RANDOM_CHINA_NAMIS_PATH+"/"+DA_SPECIES+"/"+yyyy+mm+dd+tt+"_CHINA+NAMIS_attached_removed_" \
                +DA_SPECIES+".txt"
  end if
  end if
  end if
  end if
  end if
  end if

  print(input_OBS)
  OBS=asciiread(input_OBS,(/ny,nx/),"float")
  UNDEF = -0.0009
  OBS@_FillValue = UNDEF
  min_OBS = min(OBS)
  min_CMAQ = min(before_adjust)



  if (DA_SPECIES .eq. "CO") then
    max_OBS = max(OBS)*max_ratio_CO
  else if (DA_SPECIES .eq. "O3") then
    max_OBS = max(OBS)*max_ratio
  else if (DA_SPECIES .eq. "SO2") then 
    max_OBS = max(OBS)
  else if (DA_SPECIES .eq. "NO2") then
    max_OBS = max(OBS)
  else if (DA_SPECIES .eq. "AOD") then
    max_OBS = max_AOD
  else if (DA_SPECIES .eq. "PM10") then
    max_OBS = max(OBS)*max_ratio
  end if
  end if
  end if
  end if
  end if
  end if

  print("max_OBS = " + max_OBS)
  print("min_OBS = " + min_OBS)

if (DA_SPECIES .eq. "SO2") then
  do k=0,nz-1
    do i=0,nx-1
      do j=0,ny-1
      if (k.eq.0) then
          adjusted_value(k,j,i) = OI(j,i)      
      else
        if (before_adjust(DA_TIME,0,j,i) .gt. min_OBS) then
          adjusted_value(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,0,j,i)) * before_adjust(DA_TIME,k,j,i)
        else
          adjusted_value(k,j,i) = before_adjust(DA_TIME,k,j,i)
        end if
      end if

        if (adjusted_value(k,j,i).ge.max_OBS) then
          adjusted_value(k,j,i) = max_OBS
        end if
      end do ;i
    end do ;j
  end do ;k

else if (DA_SPECIES .eq. "NO2") then
  do k=0,nz-1
    do i=0,nx-1
      do j=0,ny-1
        if (before_adjust(DA_TIME,0,j,i) .gt. min_OBS) then
          adjusted_value(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,0,j,i)) * before_adjust(DA_TIME,k,j,i)
        else
          adjusted_value(k,j,i) = before_adjust(DA_TIME,k,j,i)
        end if

        if (adjusted_value(k,j,i).ge.max_OBS) then
          adjusted_value(k,j,i) = max_OBS
        end if

      end do ;i
    end do ;j
  end do ;k

else if (DA_SPECIES .eq. "O3") then
  do k=0,nz-1
    do i=0,nx-1
      do j=0,ny-1
      if (k.eq.0) then
          adjusted_value(k,j,i) = OI(j,i) 
     
          if (adjusted_value(k,j,i).ge.5.0) then
            adjusted_value(k,j,i) = 5.0
          end if
      else
        if (before_adjust(DA_TIME,0,j,i) .gt. min_OBS) then
          adjusted_value(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,0,j,i)) * before_adjust(DA_TIME,k,j,i)

            if (adjusted_value(k,j,i).ge.0.07) then
              adjusted_value(k,j,i) = 0.07
            end if
        else
          adjusted_value(k,j,i) = before_adjust(DA_TIME,k,j,i)
        end if
      end if

        if (adjusted_value(k,j,i).ge.max_OBS) then
          adjusted_value(k,j,i) = max_OBS
        end if

      end do ;i
    end do ;j
  end do ;k

else if (DA_SPECIES .eq. "CO") then
  do k=0,nz-1
    do i=0,nx-1
      do j=0,ny-1
          adjusted_value(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,0,j,i)) * before_adjust(DA_TIME,k,j,i)

            if (adjusted_value(k,j,i).ge.max_OBS) then
              adjusted_value(k,j,i) = max_OBS
            end if
      end do ;i
    end do ;j
  end do ;k

else if (DA_SPECIES .eq. "AOD") then
  do k=0,nz-1
    do i=0,nx-1
      do j=0,ny-1
      adjusted_ASO4J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASO4J(DA_TIME,k,j,i)
      adjusted_ASO4I(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASO4I(DA_TIME,k,j,i)
      adjusted_ANO3J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANO3J(DA_TIME,k,j,i)
      adjusted_ANO3I(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANO3I(DA_TIME,k,j,i)
      adjusted_ANH4J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANH4J(DA_TIME,k,j,i)
      adjusted_ANH4I(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANH4I(DA_TIME,k,j,i)
      adjusted_ANH4K(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANH4K(DA_TIME,k,j,i)
      adjusted_ANO3K(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANO3K(DA_TIME,k,j,i)
      adjusted_AECJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AECJ(DA_TIME,k,j,i)
      adjusted_AECI(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AECI(DA_TIME,k,j,i)
      adjusted_AALK1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AALK1J(DA_TIME,k,j,i)
      adjusted_AALK2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AALK2J(DA_TIME,k,j,i)
      adjusted_ABNZ1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ABNZ1J(DA_TIME,k,j,i)
      adjusted_ABNZ2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ABNZ2J(DA_TIME,k,j,i)
      adjusted_ABNZ3J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ABNZ3J(DA_TIME,k,j,i)
      adjusted_ATOL1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ATOL1J(DA_TIME,k,j,i)
      adjusted_ATOL2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ATOL2J(DA_TIME,k,j,i)
      adjusted_ATOL3J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ATOL3J(DA_TIME,k,j,i)
      adjusted_AXYL1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AXYL1J(DA_TIME,k,j,i)
      adjusted_AXYL2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AXYL2J(DA_TIME,k,j,i)
      adjusted_AXYL3J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AXYL3J(DA_TIME,k,j,i)
      adjusted_APAH1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APAH1J(DA_TIME,k,j,i)
      adjusted_APAH2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APAH2J(DA_TIME,k,j,i)
      adjusted_APAH3J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APAH3J(DA_TIME,k,j,i)
      adjusted_AOLGAJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AOLGAJ(DA_TIME,k,j,i)
      adjusted_AISO1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AISO1J(DA_TIME,k,j,i)
      adjusted_AISO2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AISO2J(DA_TIME,k,j,i)
      adjusted_AISO3J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AISO3J(DA_TIME,k,j,i)
      adjusted_ATRP1J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ATRP1J(DA_TIME,k,j,i)
      adjusted_ATRP2J(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ATRP2J(DA_TIME,k,j,i)
      adjusted_ASQTJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASQTJ(DA_TIME,k,j,i)
      adjusted_AOLGBJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AOLGBJ(DA_TIME,k,j,i)
      adjusted_AORGCJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AORGCJ(DA_TIME,k,j,i)
      adjusted_APOCI(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APOCI(DA_TIME,k,j,i)
      adjusted_APOCJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APOCJ(DA_TIME,k,j,i)
      adjusted_ANAJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ANAJ(DA_TIME,k,j,i)
      adjusted_ACLJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ACLJ(DA_TIME,k,j,i)
      adjusted_ACLI(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ACLI(DA_TIME,k,j,i)
      adjusted_ASEACAT(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASEACAT(DA_TIME,k,j,i)
      adjusted_ACLK(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ACLK(DA_TIME,k,j,i)
      adjusted_ASO4K(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASO4K(DA_TIME,k,j,i)
      adjusted_APNCOMI(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APNCOMI(DA_TIME,k,j,i)
      adjusted_APNCOMJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*APNCOMJ(DA_TIME,k,j,i)
      adjusted_AOTHRJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AOTHRJ(DA_TIME,k,j,i)
      adjusted_AALJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AALJ(DA_TIME,k,j,i)
      adjusted_ACAJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ACAJ(DA_TIME,k,j,i)
      adjusted_AFEJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AFEJ(DA_TIME,k,j,i)
      adjusted_ASIJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASIJ(DA_TIME,k,j,i)
      adjusted_ATIJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ATIJ(DA_TIME,k,j,i)
      adjusted_AMGJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AMGJ(DA_TIME,k,j,i)
      adjusted_AKJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AKJ(DA_TIME,k,j,i)
      adjusted_AMNJ(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*AMNJ(DA_TIME,k,j,i)
      adjusted_ACORS(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ACORS(DA_TIME,k,j,i)
      adjusted_ASOIL(k,j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i))*ASOIL(DA_TIME,k,j,i)
      end do ;i
    end do ;j
  end do ;k


  do i=0,nx-1
    do j=0,ny-1
      adjusted_AOD(j,i) = (OI(j,i)/before_adjust(DA_TIME,j,i)) * before_adjust(DA_TIME,j,i)
    end do ;i
  end do ;j

else if (DA_SPECIES .eq. "PM10") then
      adjusted_AALK1J(:,:,:) = AALK1J(DA_TIME,:,:,:)
      adjusted_AALK2J(:,:,:) = AALK2J(DA_TIME,:,:,:)
      adjusted_AXYL1J(:,:,:) = AXYL1J(DA_TIME,:,:,:)
      adjusted_AXYL2J(:,:,:) = AXYL2J(DA_TIME,:,:,:)
      adjusted_AXYL3J(:,:,:) = AXYL3J(DA_TIME,:,:,:)
      adjusted_ATOL1J(:,:,:) = ATOL1J(DA_TIME,:,:,:)
      adjusted_ATOL2J(:,:,:) = ATOL2J(DA_TIME,:,:,:)
      adjusted_ATOL3J(:,:,:) = ATOL3J(DA_TIME,:,:,:)
      adjusted_ABNZ1J(:,:,:) = ABNZ1J(DA_TIME,:,:,:)
      adjusted_ABNZ2J(:,:,:) = ABNZ2J(DA_TIME,:,:,:)
      adjusted_ABNZ3J(:,:,:) = ABNZ3J(DA_TIME,:,:,:)
      adjusted_ATRP1J(:,:,:) = ATRP1J(DA_TIME,:,:,:)
      adjusted_ATRP2J(:,:,:) = ATRP2J(DA_TIME,:,:,:)
      adjusted_AISO1J(:,:,:) = AISO1J(DA_TIME,:,:,:)
      adjusted_AISO2J(:,:,:) = AISO2J(DA_TIME,:,:,:)
      adjusted_AISO3J(:,:,:) = AISO3J(DA_TIME,:,:,:)
      adjusted_ASQTJ (:,:,:) = ASQTJ(DA_TIME,:,:,:)
      adjusted_AORGCJ(:,:,:) = AORGCJ(DA_TIME,:,:,:)
      adjusted_APOCJ (:,:,:) = APOCJ(DA_TIME,:,:,:)
      adjusted_APOCI (:,:,:) = APOCI(DA_TIME,:,:,:)
      adjusted_AOLGAJ(:,:,:) = AOLGAJ(DA_TIME,:,:,:)
      adjusted_AOLGBJ(:,:,:) = AOLGBJ(DA_TIME,:,:,:)
      adjusted_APNCOMJ(:,:,:) = APNCOMJ(DA_TIME,:,:,:)
      adjusted_APNCOMI(:,:,:) = APNCOMI(DA_TIME,:,:,:)
      adjusted_APAH1J(:,:,:) = APAH1J(DA_TIME,:,:,:)
      adjusted_APAH2J(:,:,:) = APAH2J(DA_TIME,:,:,:)
      adjusted_APAH3J(:,:,:) = APAH3J(DA_TIME,:,:,:)
      adjusted_AOTHRJ(:,:,:) = AOTHRJ(DA_TIME,:,:,:)

      adjusted_AECJ(:,:,:) = AECJ(DA_TIME,:,:,:)
      adjusted_AECI(:,:,:) = AECI(DA_TIME,:,:,:)

      adjusted_AFEJ(:,:,:) = AFEJ(DA_TIME,:,:,:)
      adjusted_AALJ(:,:,:) = AALJ(DA_TIME,:,:,:)
      adjusted_ASIJ(:,:,:) = ASIJ(DA_TIME,:,:,:)
      adjusted_ATIJ(:,:,:) = ATIJ(DA_TIME,:,:,:)
      adjusted_ACAJ(:,:,:) = ACAJ(DA_TIME,:,:,:)
      adjusted_AMGJ(:,:,:) = AMGJ(DA_TIME,:,:,:)
      adjusted_AKJ(:,:,:) = AKJ(DA_TIME,:,:,:)
      adjusted_AMNJ(:,:,:) = AMNJ(DA_TIME,:,:,:)
      adjusted_ACORS(:,:,:) = ACORS(DA_TIME,:,:,:)
      adjusted_ASOIL(:,:,:) = ASOIL(DA_TIME,:,:,:)

      adjusted_ANAJ(:,:,:) = ANAJ(DA_TIME,:,:,:)
      adjusted_ACLI(:,:,:) = ACLI(DA_TIME,:,:,:)
      adjusted_ACLJ(:,:,:) = ACLJ(DA_TIME,:,:,:)
      adjusted_ACLK(:,:,:) = ACLK(DA_TIME,:,:,:)
      adjusted_ASEACAT(:,:,:) = ASEACAT(DA_TIME,:,:,:)

  ALL_PM25_for_OA_EC = AALK1J(DA_TIME,0,:,:)+AALK2J(DA_TIME,0,:,:)+AXYL1J(DA_TIME,0,:,:)+AXYL2J(DA_TIME,0,:,:)+ \
              AXYL3J(DA_TIME,0,:,:)+ATOL1J(DA_TIME,0,:,:)+ATOL2J(DA_TIME,0,:,:)+ATOL3J(DA_TIME,0,:,:)+\
              ABNZ1J(DA_TIME,0,:,:)+ABNZ2J(DA_TIME,0,:,:)+ABNZ3J(DA_TIME,0,:,:)+ATRP1J(DA_TIME,0,:,:)+\
              ATRP2J(DA_TIME,0,:,:)+AISO1J(DA_TIME,0,:,:)+AISO2J(DA_TIME,0,:,:)+\
              AISO3J(DA_TIME,0,:,:)+ASQTJ(DA_TIME,0,:,:)+AORGCJ(DA_TIME,0,:,:)+APOCJ(DA_TIME,0,:,:)+\
              APOCI(DA_TIME,0,:,:)+AOLGAJ(DA_TIME,0,:,:)+AOLGBJ(DA_TIME,0,:,:)+\
              APNCOMJ(DA_TIME,0,:,:)+APNCOMI(DA_TIME,0,:,:)+APAH1J(DA_TIME,0,:,:)+\
              APAH2J(DA_TIME,0,:,:)+APAH3J(DA_TIME,0,:,:)+\
              AECI(DA_TIME,0,:,:)+AECJ(DA_TIME,0,:,:)       ;#29


  ALL_PM25_for_OTHER_SS_DUST = AFEJ(DA_TIME,0,:,:)+ACAJ(DA_TIME,0,:,:)+ASIJ(DA_TIME,0,:,:)+\
              ATIJ(DA_TIME,0,:,:)+AALJ(DA_TIME,0,:,:)+AMGJ(DA_TIME,0,:,:)+\
              AKJ(DA_TIME,0,:,:)+AMNJ(DA_TIME,0,:,:)+\
              ACLI(DA_TIME,0,:,:)+ACLJ(DA_TIME,0,:,:)+ANAJ(DA_TIME,0,:,:)+\
              AOTHRJ(DA_TIME,0,:,:)      ;#12

  ALL_coarse_PM10_25 = ACORS(DA_TIME,0,:,:)+ASOIL(DA_TIME,0,:,:)+\
              ACLK(DA_TIME,0,:,:)+ASEACAT(DA_TIME,0,:,:)     ;#4


  CMAQ_start = stringtointeger(getenv("sYEAR")+getenv("sMON")+getenv("sDAY"))
  be_PM10_PM25_FILE=CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
               +"_"+CMAQ_start+"_AOD_PM.nc"

  be_PM10_PM25=addfile(be_PM10_PM25_FILE, "r")
  PM10_be=be_PM10_PM25->PM10(DA_TIME,:,:)
  PM25_be=be_PM10_PM25->PM25(DA_TIME,:,:)


  delta_PM10 := new((/ny, nx/),"float")
  delta_PM25 := new((/ny, nx/),"float")
  delta_coarse_PM10_25 := new((/ny, nx/),"float")

      delta_PM10(:,:) = OI(:,:) - before_adjust(DA_TIME,:,:)
      delta_PM25(:,:) = delta_PM10(:,:) * (PM25_be(:,:) / PM10_be(:,:))
      delta_coarse_PM10_25(:,:) = delta_PM10(:,:) - delta_PM25(:,:) 

      delta_PM25_for_OA_EC = delta_PM25 * (24.5+3.5)/(25+24.5+3.5)
      delta_PM25_for_OTHER_SS_DUST = delta_PM25 * 25 / (25+24.5+3.5)


;### OA
      adjusted_AALK1J(0,:,:)  = ( (AALK1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AALK1J(DA_TIME,0,:,:)
      adjusted_AALK2J(0,:,:)  = ( (AALK2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AALK2J(DA_TIME,0,:,:)
      adjusted_AXYL1J(0,:,:)  = ( (AXYL1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AXYL1J(DA_TIME,0,:,:)
      adjusted_AXYL2J(0,:,:)  = ( (AXYL2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AXYL2J(DA_TIME,0,:,:)
      adjusted_AXYL3J(0,:,:)  = ( (AXYL3J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AXYL3J(DA_TIME,0,:,:)
      adjusted_ATOL1J(0,:,:)  = ( (ATOL1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ATOL1J(DA_TIME,0,:,:)
      adjusted_ATOL2J(0,:,:)  = ( (ATOL2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ATOL2J(DA_TIME,0,:,:)
      adjusted_ATOL3J(0,:,:)  = ( (ATOL3J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ATOL3J(DA_TIME,0,:,:)
      adjusted_ABNZ1J(0,:,:)  = ( (ABNZ1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ABNZ1J(DA_TIME,0,:,:)
      adjusted_ABNZ2J(0,:,:)  = ( (ABNZ2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ABNZ2J(DA_TIME,0,:,:)
      adjusted_ABNZ3J(0,:,:)  = ( (ABNZ3J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ABNZ3J(DA_TIME,0,:,:)
      adjusted_ATRP1J(0,:,:)  = ( (ATRP1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ATRP1J(DA_TIME,0,:,:)
      adjusted_ATRP2J(0,:,:)  = ( (ATRP2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ATRP2J(DA_TIME,0,:,:)
      adjusted_AISO1J(0,:,:)  = ( (AISO1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AISO1J(DA_TIME,0,:,:)
      adjusted_AISO2J(0,:,:)  = ( (AISO2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AISO2J(DA_TIME,0,:,:)
      adjusted_AISO3J(0,:,:)  = ( (AISO3J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AISO3J(DA_TIME,0,:,:)
      adjusted_ASQTJ(0,:,:)   = ( (ASQTJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+ASQTJ(DA_TIME,0,:,:)
      adjusted_AORGCJ(0,:,:)  = ( (AORGCJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AORGCJ(DA_TIME,0,:,:)
      adjusted_APOCJ(0,:,:)   = ( (APOCJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APOCJ(DA_TIME,0,:,:)
      adjusted_APOCI(0,:,:)   = ( (APOCI(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APOCI(DA_TIME,0,:,:)
      adjusted_AOLGAJ(0,:,:)  = ( (AOLGAJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AOLGAJ(DA_TIME,0,:,:)
      adjusted_AOLGBJ(0,:,:)  = ( (AOLGBJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APNCOMJ(DA_TIME,0,:,:)
      adjusted_APNCOMI(0,:,:) = ( (APNCOMI(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AOLGBJ(DA_TIME,0,:,:)
      adjusted_APNCOMJ(0,:,:) = ( (APNCOMJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APNCOMI(DA_TIME,0,:,:)
      adjusted_APAH1J(0,:,:)  = ( (APAH1J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APAH1J(DA_TIME,0,:,:)
      adjusted_APAH2J(0,:,:)  = ( (APAH2J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APAH2J(DA_TIME,0,:,:)
      adjusted_APAH3J(0,:,:)  = ( (APAH3J(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+APAH3J(DA_TIME,0,:,:)

;### EC
      adjusted_AECJ(0,:,:)    = ( (AECJ(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AECJ(DA_TIME,0,:,:)
      adjusted_AECI(0,:,:)    = ( (AECI(DA_TIME,0,:,:)/ALL_PM25_for_OA_EC(:,:))*delta_PM25_for_OA_EC(:,:) )+AECI(DA_TIME,0,:,:)


;### AOTHR
      adjusted_AOTHRJ(0,:,:)  = ( (AOTHRJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+AOTHRJ(DA_TIME,0,:,:)

;### DUST_J
      adjusted_AFEJ(0,:,:)    = ( (AFEJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+AFEJ(DA_TIME,0,:,:)
      adjusted_AALJ(0,:,:)    = ( (AALJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+AALJ(DA_TIME,0,:,:)
      adjusted_ASIJ(0,:,:)    = ( (ASIJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+ASIJ(DA_TIME,0,:,:)
      adjusted_ATIJ(0,:,:)    = ( (ATIJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+ATIJ(DA_TIME,0,:,:)
      adjusted_ACAJ(0,:,:)    = ( (ACAJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+ACAJ(DA_TIME,0,:,:)
      adjusted_AMGJ(0,:,:)    = ( (AMGJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+AMGJ(DA_TIME,0,:,:)
      adjusted_AKJ(0,:,:)    = ( (AKJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+AKJ(DA_TIME,0,:,:)
      adjusted_AMNJ(0,:,:)    = ( (AMNJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+AMNJ(DA_TIME,0,:,:)

;### DUST_K
      adjusted_ACORS(0,:,:)    = ( (ACORS(DA_TIME,0,:,:)/ALL_coarse_PM10_25(:,:))*delta_coarse_PM10_25(:,:) )+ACORS(DA_TIME,0,:,:)
      adjusted_ASOIL(0,:,:)    = ( (ASOIL(DA_TIME,0,:,:)/ALL_coarse_PM10_25(:,:))*delta_coarse_PM10_25(:,:) )+ASOIL(DA_TIME,0,:,:)

;### SS_IJ
      adjusted_ANAJ(0,:,:)    = ( (ANAJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+ANAJ(DA_TIME,0,:,:)
      adjusted_ACLI(0,:,:)    = ( (ACLI(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+ACLI(DA_TIME,0,:,:)
      adjusted_ACLJ(0,:,:)    = ( (ACLJ(DA_TIME,0,:,:)/ALL_PM25_for_OTHER_SS_DUST(:,:))*delta_PM25_for_OTHER_SS_DUST(:,:) )+ACLJ(DA_TIME,0,:,:)

;### SS_K
      adjusted_ACLK(0,:,:)    = ( (ACLK(DA_TIME,0,:,:)/ALL_coarse_PM10_25(:,:))*delta_coarse_PM10_25(:,:) )+ACLK(DA_TIME,0,:,:)
      adjusted_ASEACAT(0,:,:)    = ( (ASEACAT(DA_TIME,0,:,:)/ALL_coarse_PM10_25(:,:))*delta_coarse_PM10_25(:,:) )+ASEACAT(DA_TIME,0,:,:)
        
;### OA
    adjusted_AALK1J  = where(adjusted_AALK1J.le.0,AALK1J(DA_TIME,:,:,:),adjusted_AALK1J)
    adjusted_AALK2J  = where(adjusted_AALK2J.le.0,AALK2J(DA_TIME,:,:,:),adjusted_AALK2J)
    adjusted_AXYL1J  = where(adjusted_AXYL1J.le.0,AXYL1J(DA_TIME,:,:,:),adjusted_AXYL1J)
    adjusted_AXYL2J  = where(adjusted_AXYL2J.le.0,AXYL2J(DA_TIME,:,:,:),adjusted_AXYL2J)
    adjusted_AXYL3J  = where(adjusted_AXYL3J.le.0,AXYL3J(DA_TIME,:,:,:),adjusted_AXYL3J)
    adjusted_ATOL1J  = where(adjusted_ATOL1J.le.0,ATOL1J(DA_TIME,:,:,:),adjusted_ATOL1J)
    adjusted_ATOL2J  = where(adjusted_ATOL2J.le.0,ATOL2J(DA_TIME,:,:,:),adjusted_ATOL2J)
    adjusted_ATOL3J  = where(adjusted_ATOL3J.le.0,ATOL3J(DA_TIME,:,:,:),adjusted_ATOL3J)
    adjusted_ABNZ1J  = where(adjusted_ABNZ1J.le.0,ABNZ1J(DA_TIME,:,:,:),adjusted_ABNZ1J)
    adjusted_ABNZ2J  = where(adjusted_ABNZ2J.le.0,ABNZ2J(DA_TIME,:,:,:),adjusted_ABNZ2J)
    adjusted_ABNZ3J  = where(adjusted_ABNZ3J.le.0,ABNZ3J(DA_TIME,:,:,:),adjusted_ABNZ3J)
    adjusted_ATRP1J  = where(adjusted_ATRP1J.le.0,ATRP1J(DA_TIME,:,:,:),adjusted_ATRP1J)
    adjusted_ATRP2J  = where(adjusted_ATRP2J.le.0,ATRP2J(DA_TIME,:,:,:),adjusted_ATRP2J)
    adjusted_AISO1J  = where(adjusted_AISO1J.le.0,AISO1J(DA_TIME,:,:,:),adjusted_AISO1J)
    adjusted_AISO2J  = where(adjusted_AISO2J.le.0,AISO2J(DA_TIME,:,:,:),adjusted_AISO2J)
    adjusted_AISO3J  = where(adjusted_AISO3J.le.0,AISO3J(DA_TIME,:,:,:),adjusted_AISO3J)
    adjusted_ASQTJ   = where(adjusted_ASQTJ.le.0,ASQTJ(DA_TIME,:,:,:),adjusted_ASQTJ)
    adjusted_AORGCJ  = where(adjusted_AORGCJ.le.0,AORGCJ(DA_TIME,:,:,:),adjusted_AORGCJ)
    adjusted_APOCJ   = where(adjusted_APOCJ.le.0,APOCJ(DA_TIME,:,:,:),adjusted_APOCJ)
    adjusted_APOCI   = where(adjusted_APOCI.le.0,APOCI(DA_TIME,:,:,:),adjusted_APOCI)
    adjusted_AOLGAJ  = where(adjusted_AOLGAJ.le.0,AOLGAJ(DA_TIME,:,:,:),adjusted_AOLGAJ)
    adjusted_AOLGBJ  = where(adjusted_AOLGBJ.le.0,AOLGBJ(DA_TIME,:,:,:),adjusted_AOLGBJ)
    adjusted_APNCOMJ = where(adjusted_APNCOMJ.le.0,APNCOMJ(DA_TIME,:,:,:),adjusted_APNCOMJ)
    adjusted_APNCOMI = where(adjusted_APNCOMI.le.0,APNCOMI(DA_TIME,:,:,:),adjusted_APNCOMI)
    adjusted_APAH1J  = where(adjusted_APAH1J.le.0,APAH1J(DA_TIME,:,:,:),adjusted_APAH1J)
    adjusted_APAH2J  = where(adjusted_APAH2J.le.0,APAH2J(DA_TIME,:,:,:),adjusted_APAH2J)
    adjusted_APAH3J  = where(adjusted_APAH3J.le.0,APAH3J(DA_TIME,:,:,:),adjusted_APAH3J)

;### EC
    adjusted_AECJ    = where(adjusted_AECJ.le.0,AECJ(DA_TIME,:,:,:),adjusted_AECJ)
    adjusted_AECI    = where(adjusted_AECI.le.0,AECI(DA_TIME,:,:,:),adjusted_AECI)

;### AOTHR
    adjusted_AOTHRJ  = where(adjusted_AOTHRJ.le.0,AOTHRJ(DA_TIME,:,:,:),adjusted_AOTHRJ)

;### DUST_J
    adjusted_AFEJ    = where(adjusted_AFEJ.le.0,AFEJ(DA_TIME,:,:,:),adjusted_AFEJ)
    adjusted_AALJ    = where(adjusted_AALJ.le.0,AALJ(DA_TIME,:,:,:),adjusted_AALJ)
    adjusted_ASIJ    = where(adjusted_ASIJ.le.0,ASIJ(DA_TIME,:,:,:),adjusted_ASIJ)
    adjusted_ATIJ    = where(adjusted_ATIJ.le.0,ATIJ(DA_TIME,:,:,:),adjusted_ATIJ)
    adjusted_ACAJ    = where(adjusted_ACAJ.le.0,ACAJ(DA_TIME,:,:,:),adjusted_ACAJ)
    adjusted_AMGJ    = where(adjusted_AMGJ.le.0,AMGJ(DA_TIME,:,:,:),adjusted_AMGJ)
    adjusted_AKJ     = where(adjusted_AKJ.le.0,AKJ(DA_TIME,:,:,:),adjusted_AKJ)
    adjusted_AMNJ    = where(adjusted_AMNJ.le.0,AMNJ(DA_TIME,:,:,:),adjusted_AMNJ)

;### DUST_K
    adjusted_ACORS   = where(adjusted_ACORS.le.0,ACORS(DA_TIME,:,:,:),adjusted_ACORS)
    adjusted_ASOIL   = where(adjusted_ASOIL.le.0,ASOIL(DA_TIME,:,:,:),adjusted_ASOIL)

;### SS_IJ
    adjusted_ANAJ    = where(adjusted_ANAJ.le.0,ANAJ(DA_TIME,:,:,:),adjusted_ANAJ)
    adjusted_ACLI    = where(adjusted_ACLI.le.0,ACLI(DA_TIME,:,:,:),adjusted_ACLI)
    adjusted_ACLJ    = where(adjusted_ACLJ.le.0,ACLJ(DA_TIME,:,:,:),adjusted_ACLJ)

;### SS_K
    adjusted_ACLK    = where(adjusted_ACLK.le.0,ACLK(DA_TIME,:,:,:),adjusted_ACLK)
    adjusted_ASEACAT    = where(adjusted_ASEACAT.le.0,ASEACAT(DA_TIME,:,:,:),adjusted_ASEACAT)


  do k=0,nz-1
    do i=0,nx-1
      do j=0,ny-1

      if (adjusted_AALK1J(0,j,i) .gt. 0.00000001) then
        adjusted_AALK1J(k,j,i)  = ( adjusted_AALK1J(0,j,i)/AALK1J(DA_TIME,0,j,i) )*AALK1J(DA_TIME,k,j,i)
      end if

      if (adjusted_AALK2J(0,j,i) .gt. 0.00000001) then
        adjusted_AALK2J(k,j,i)  = ( adjusted_AALK2J(0,j,i)/AALK2J(DA_TIME,0,j,i) )*AALK2J(DA_TIME,k,j,i)
      end if

      if (adjusted_AXYL1J(0,j,i) .gt. 0.00000001) then
        adjusted_AXYL1J(k,j,i)  = ( adjusted_AXYL1J(0,j,i)/AXYL1J(DA_TIME,0,j,i) )*AXYL1J(DA_TIME,k,j,i)
      end if

      if (adjusted_AXYL2J(0,j,i) .gt. 0.00000001) then
        adjusted_AXYL2J(k,j,i)  = ( adjusted_AXYL2J(0,j,i)/AXYL2J(DA_TIME,0,j,i) )*AXYL2J(DA_TIME,k,j,i)
      end if

      if (adjusted_AXYL3J(0,j,i) .gt. 0.00000001) then
        adjusted_AXYL3J(k,j,i)  = ( adjusted_AXYL3J(0,j,i)/AXYL3J(DA_TIME,0,j,i) )*AXYL3J(DA_TIME,k,j,i)
      end if

      if (adjusted_ATOL1J(0,j,i) .gt. 0.00000001) then
        adjusted_ATOL1J(k,j,i)  = ( adjusted_ATOL1J(0,j,i)/ATOL1J(DA_TIME,0,j,i) )*ATOL1J(DA_TIME,k,j,i)
      end if

      if (adjusted_ATOL2J(0,j,i) .gt. 0.00000001) then
        adjusted_ATOL2J(k,j,i)  = ( adjusted_ATOL2J(0,j,i)/ATOL2J(DA_TIME,0,j,i) )*ATOL2J(DA_TIME,k,j,i)
      end if

      if (adjusted_ATOL3J(0,j,i) .gt. 0.00000001) then
        adjusted_ATOL3J(k,j,i)  = ( adjusted_ATOL3J(0,j,i)/ATOL3J(DA_TIME,0,j,i) )*ATOL3J(DA_TIME,k,j,i)
      end if

      if (adjusted_ABNZ1J(0,j,i) .gt. 0.00000001) then
        adjusted_ABNZ1J(k,j,i)  = ( adjusted_ABNZ1J(0,j,i)/ABNZ1J(DA_TIME,0,j,i) )*ABNZ1J(DA_TIME,k,j,i)
      end if

      if (adjusted_ABNZ2J(0,j,i) .gt. 0.00000001) then
        adjusted_ABNZ2J(k,j,i)  = ( adjusted_ABNZ2J(0,j,i)/ABNZ2J(DA_TIME,0,j,i) )*ABNZ2J(DA_TIME,k,j,i)
      end if

      if (adjusted_ABNZ3J(0,j,i) .gt. 0.00000001) then
        adjusted_ABNZ3J(k,j,i)  = ( adjusted_ABNZ3J(0,j,i)/ABNZ3J(DA_TIME,0,j,i) )*ABNZ3J(DA_TIME,k,j,i)
      end if

      if (adjusted_ATRP1J(0,j,i) .gt. 0.00000001) then
        adjusted_ATRP1J(k,j,i)  = ( adjusted_ATRP1J(0,j,i)/ATRP1J(DA_TIME,0,j,i) )*ATRP1J(DA_TIME,k,j,i)
      end if

      if (adjusted_ATRP2J(0,j,i) .gt. 0.00000001) then
        adjusted_ATRP2J(k,j,i)  = ( adjusted_ATRP2J(0,j,i)/ATRP2J(DA_TIME,0,j,i) )*ATRP2J(DA_TIME,k,j,i)
      end if

      if (adjusted_AISO1J(0,j,i) .gt. 0.00000001) then
        adjusted_AISO1J(k,j,i)  = ( adjusted_AISO1J(0,j,i)/AISO1J(DA_TIME,0,j,i) )*AISO1J(DA_TIME,k,j,i)
      end if

      if (adjusted_AISO2J(0,j,i) .gt. 0.00000001) then
        adjusted_AISO2J(k,j,i)  = ( adjusted_AISO2J(0,j,i)/AISO2J(DA_TIME,0,j,i) )*AISO2J(DA_TIME,k,j,i)
      end if

      if (adjusted_AISO3J(0,j,i) .gt. 0.00000001) then
        adjusted_AISO3J(k,j,i)  = ( adjusted_AISO3J(0,j,i)/AISO3J(DA_TIME,0,j,i) )*AISO3J(DA_TIME,k,j,i)
      end if

      if (adjusted_ASQTJ(0,j,i) .gt. 0.00000001) then
        adjusted_ASQTJ(k,j,i)   = ( adjusted_ASQTJ(0,j,i)/ASQTJ(DA_TIME,0,j,i) )*ASQTJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AORGCJ(0,j,i) .gt. 0.00000001) then
        adjusted_AORGCJ(k,j,i)  = ( adjusted_AORGCJ(0,j,i)/AORGCJ(DA_TIME,0,j,i) )*AORGCJ(DA_TIME,k,j,i)
      end if

      if (adjusted_APOCJ(0,j,i) .gt. 0.00000001) then
        adjusted_APOCJ(k,j,i)   = ( adjusted_APOCJ(0,j,i)/APOCJ(DA_TIME,0,j,i) )*APOCJ(DA_TIME,k,j,i)
      end if

      if (adjusted_APOCI(0,j,i) .gt. 0.00000001) then
        adjusted_APOCI(k,j,i)   = ( adjusted_APOCI(0,j,i)/APOCI(DA_TIME,0,j,i) )*APOCI(DA_TIME,k,j,i)
      end if

      if (adjusted_AOLGAJ(0,j,i) .gt. 0.00000001) then
        adjusted_AOLGAJ(k,j,i)  = ( adjusted_AOLGAJ(0,j,i)/AOLGAJ(DA_TIME,0,j,i) )*AOLGAJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AOLGBJ(0,j,i) .gt. 0.00000001) then
        adjusted_AOLGBJ(k,j,i)  = ( adjusted_AOLGBJ(0,j,i)/AOLGBJ(DA_TIME,0,j,i) )*AOLGBJ(DA_TIME,k,j,i)
      end if

      if (adjusted_APNCOMJ(0,j,i) .gt. 0.00000001) then
        adjusted_APNCOMJ(k,j,i) = ( adjusted_APNCOMJ(0,j,i)/APNCOMJ(DA_TIME,0,j,i) )*APNCOMJ(DA_TIME,k,j,i)
      end if

      if (adjusted_APNCOMI(0,j,i) .gt. 0.00000001) then
        adjusted_APNCOMI(k,j,i) = ( adjusted_APNCOMI(0,j,i)/APNCOMI(DA_TIME,0,j,i) )*APNCOMI(DA_TIME,k,j,i)
      end if

      if (adjusted_APAH1J(0,j,i) .gt. 0.00000001) then
        adjusted_APAH1J(k,j,i)  = ( adjusted_APAH1J(0,j,i)/APAH1J(DA_TIME,0,j,i) )*APAH1J(DA_TIME,k,j,i)
      end if

      if (adjusted_APAH2J(0,j,i) .gt. 0.00000001) then
        adjusted_APAH2J(k,j,i)  = ( adjusted_APAH2J(0,j,i)/APAH2J(DA_TIME,0,j,i) )*APAH2J(DA_TIME,k,j,i)
      end if

      if (adjusted_APAH3J(0,j,i) .gt. 0.00000001) then
        adjusted_APAH3J(k,j,i)  = ( adjusted_APAH3J(0,j,i)/APAH3J(DA_TIME,0,j,i) )*APAH3J(DA_TIME,k,j,i)
      end if

      if (adjusted_AOTHRJ(0,j,i) .gt. 0.00000001) then
        adjusted_AOTHRJ(k,j,i)  = ( adjusted_AOTHRJ(0,j,i)/AOTHRJ(DA_TIME,0,j,i) )*AOTHRJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AECJ(0,j,i) .gt. 0.00000001) then
        adjusted_AECJ(k,j,i)    = ( adjusted_AECJ(0,j,i)/AECJ(DA_TIME,0,j,i) )*AECJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AECI(0,j,i) .gt. 0.00000001) then
        adjusted_AECI(k,j,i)    = ( adjusted_AECI(0,j,i)/AECI(DA_TIME,0,j,i) )*AECI(DA_TIME,k,j,i)
      end if

      if (adjusted_AFEJ(0,j,i) .gt. 0.00000001) then
        adjusted_AFEJ(k,j,i)    = ( adjusted_AFEJ(0,j,i)/AFEJ(DA_TIME,0,j,i) )*AFEJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AALJ(0,j,i) .gt. 0.00000001) then
        adjusted_AALJ(k,j,i)    = ( adjusted_AALJ(0,j,i)/AALJ(DA_TIME,0,j,i) )*AALJ(DA_TIME,k,j,i)
      end if

      if (adjusted_ASIJ(0,j,i) .gt. 0.00000001) then
        adjusted_ASIJ(k,j,i)    = ( adjusted_ASIJ(0,j,i)/ASIJ(DA_TIME,0,j,i) )*ASIJ(DA_TIME,k,j,i)
      end if

      if (adjusted_ATIJ(0,j,i) .gt. 0.00000001) then
        adjusted_ATIJ(k,j,i)    = ( adjusted_ATIJ(0,j,i)/ATIJ(DA_TIME,0,j,i) )*ATIJ(DA_TIME,k,j,i)
      end if

      if (adjusted_ACAJ(0,j,i) .gt. 0.00000001) then
        adjusted_ACAJ(k,j,i)    = ( adjusted_ACAJ(0,j,i)/ACAJ(DA_TIME,0,j,i) )*ACAJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AMGJ(0,j,i) .gt. 0.00000001) then
        adjusted_AMGJ(k,j,i)    = ( adjusted_AMGJ(0,j,i)/AMGJ(DA_TIME,0,j,i) )*AMGJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AKJ(0,j,i) .gt. 0.00000001) then
        adjusted_AKJ(k,j,i)    = ( adjusted_AKJ(0,j,i)/AKJ(DA_TIME,0,j,i) )*AKJ(DA_TIME,k,j,i)
      end if

      if (adjusted_AMNJ(0,j,i) .gt. 0.00000001) then
        adjusted_AMNJ(k,j,i)    = ( adjusted_AMNJ(0,j,i)/AMNJ(DA_TIME,0,j,i) )*AMNJ(DA_TIME,k,j,i)
      end if

      if (adjusted_ACORS(0,j,i) .gt. 0.00000001) then
        adjusted_ACORS(k,j,i)    = ( adjusted_ACORS(0,j,i)/ACORS(DA_TIME,0,j,i) )*ACORS(DA_TIME,k,j,i)
      end if

      if (adjusted_ASOIL(0,j,i) .gt. 0.00000001) then
        adjusted_ASOIL(k,j,i)    = ( adjusted_ASOIL(0,j,i)/ASOIL(DA_TIME,0,j,i) )*ASOIL(DA_TIME,k,j,i)
      end if

      if (adjusted_ANAJ(0,j,i) .gt. 0.00000001) then
        adjusted_ANAJ(k,j,i)    = ( adjusted_ANAJ(0,j,i)/ANAJ(DA_TIME,0,j,i) )*ANAJ(DA_TIME,k,j,i)
      end if

      if (adjusted_ACLI(0,j,i) .gt. 0.00000001) then
        adjusted_ACLI(k,j,i)    = ( adjusted_ACLI(0,j,i)/ACLI(DA_TIME,0,j,i) )*ACLI(DA_TIME,k,j,i)
      end if

      if (adjusted_ACLJ(0,j,i) .gt. 0.00000001) then
        adjusted_ACLJ(k,j,i)    = ( adjusted_ACLJ(0,j,i)/ACLJ(DA_TIME,0,j,i) )*ACLJ(DA_TIME,k,j,i)
      end if

      if (adjusted_ACLK(0,j,i) .gt. 0.00000001) then
        adjusted_ACLK(k,j,i)    = ( adjusted_ACLK(0,j,i)/ACLK(DA_TIME,0,j,i) )*ACLK(DA_TIME,k,j,i)
      end if

      if (adjusted_ASEACAT(0,j,i) .gt. 0.00000001) then
        adjusted_ASEACAT(k,j,i)    = ( adjusted_ASEACAT(0,j,i)/ASEACAT(DA_TIME,0,j,i) )*ASEACAT(DA_TIME,k,j,i)
      end if

      end do ;i
    end do ;j
  end do ;k

    max_AALK1J = max(adjusted_AALK1J(0,:,:))
    max_AALK2J = max(adjusted_AALK2J(0,:,:))
    max_AXYL1J = max(adjusted_AXYL1J(0,:,:))
    max_AXYL2J = max(adjusted_AXYL2J(0,:,:))
    max_AXYL3J = max(adjusted_AXYL3J(0,:,:))
    max_ATOL1J = max(adjusted_ATOL1J(0,:,:))
    max_ATOL2J = max(adjusted_ATOL2J(0,:,:))
    max_ATOL3J = max(adjusted_ATOL3J(0,:,:))
    max_ABNZ1J = max(adjusted_ABNZ1J(0,:,:))
    max_ABNZ2J = max(adjusted_ABNZ2J(0,:,:))
    max_ABNZ3J = max(adjusted_ABNZ3J(0,:,:))
    max_ATRP1J = max(adjusted_ATRP1J(0,:,:))
    max_ATRP2J = max(adjusted_ATRP2J(0,:,:))
    max_AISO1J = max(adjusted_AISO1J(0,:,:))
    max_AISO2J = max(adjusted_AISO2J(0,:,:))
    max_AISO3J = max(adjusted_AISO3J(0,:,:))
    max_ASQTJ = max(adjusted_ASQTJ(0,:,:))
    max_AORGCJ = max(adjusted_AORGCJ(0,:,:))
    max_APOCJ = max(adjusted_APOCJ(0,:,:))
    max_APOCI = max(adjusted_APOCI(0,:,:))
    max_AOLGAJ = max(adjusted_AOLGAJ(0,:,:))
    max_AOLGBJ = max(adjusted_AOLGBJ(0,:,:))
    max_APNCOMJ = max(adjusted_APNCOMJ(0,:,:))
    max_APNCOMI = max(adjusted_APNCOMI(0,:,:))
    max_APAH1J = max(adjusted_APAH1J(0,:,:))
    max_APAH2J = max(adjusted_APAH2J(0,:,:))
    max_APAH3J = max(adjusted_APAH3J(0,:,:))
    max_AOTHRJ = max(adjusted_AOTHRJ(0,:,:))

    max_AECJ = max(adjusted_AECJ(0,:,:))
    max_AECI = max(adjusted_AECI(0,:,:))

    max_AFEJ = max(adjusted_AFEJ(0,:,:))
    max_AALJ = max(adjusted_AALJ(0,:,:))
    max_ASIJ = max(adjusted_ASIJ(0,:,:))
    max_ATIJ = max(adjusted_ATIJ(0,:,:))
    max_ACAJ = max(adjusted_ACAJ(0,:,:))
    max_AMGJ = max(adjusted_AMGJ(0,:,:))
    max_AKJ = max(adjusted_AKJ(0,:,:))
    max_AMNJ = max(adjusted_AMNJ(0,:,:))
    max_ACORS = max(adjusted_ACORS(0,:,:))
    max_ASOIL = max(adjusted_ASOIL(0,:,:))
    max_ANAJ = max(adjusted_ANAJ(0,:,:))
    max_ACLI = max(adjusted_ACLI(0,:,:))
    max_ACLJ = max(adjusted_ACLJ(0,:,:))
    max_ACLK = max(adjusted_ACLK(0,:,:))
    max_ASEACAT = max(adjusted_ASEACAT(0,:,:))

    adjusted_AALK1J  = where(adjusted_AALK1J.gt.max_AALK1J,max_AALK1J,adjusted_AALK1J)
    adjusted_AALK2J  = where(adjusted_AALK2J.gt.max_AALK2J,max_AALK2J,adjusted_AALK2J)
    adjusted_AXYL1J  = where(adjusted_AXYL1J.gt.max_AXYL1J,max_AXYL1J,adjusted_AXYL1J)
    adjusted_AXYL2J  = where(adjusted_AXYL2J.gt.max_AXYL2J,max_AXYL2J,adjusted_AXYL2J)
    adjusted_AXYL3J  = where(adjusted_AXYL3J.gt.max_AXYL3J,max_AXYL3J,adjusted_AXYL3J)
    adjusted_ATOL1J  = where(adjusted_ATOL1J.gt.max_ATOL1J,max_ATOL1J,adjusted_ATOL1J)
    adjusted_ATOL2J  = where(adjusted_ATOL2J.gt.max_ATOL2J,max_ATOL2J,adjusted_ATOL2J)
    adjusted_ATOL3J  = where(adjusted_ATOL3J.gt.max_ATOL3J,max_ATOL3J,adjusted_ATOL3J)
    adjusted_ABNZ1J  = where(adjusted_ABNZ1J.gt.max_ABNZ1J,max_ABNZ1J,adjusted_ABNZ1J)
    adjusted_ABNZ2J  = where(adjusted_ABNZ2J.gt.max_ABNZ2J,max_ABNZ2J,adjusted_ABNZ2J)
    adjusted_ABNZ3J  = where(adjusted_ABNZ3J.gt.max_ABNZ3J,max_ABNZ3J,adjusted_ABNZ3J)
    adjusted_ATRP1J  = where(adjusted_ATRP1J.gt.max_ATRP1J,max_ATRP1J,adjusted_ATRP1J)
    adjusted_ATRP2J  = where(adjusted_ATRP2J.gt.max_ATRP2J,max_ATRP2J,adjusted_ATRP2J)
    adjusted_AISO1J  = where(adjusted_AISO1J.gt.max_AISO1J,max_AISO1J,adjusted_AISO1J)
    adjusted_AISO2J  = where(adjusted_AISO2J.gt.max_AISO2J,max_AISO2J,adjusted_AISO2J)
    adjusted_AISO3J  = where(adjusted_AISO3J.gt.max_AISO3J,max_AISO3J,adjusted_AISO3J)
    adjusted_ASQTJ   = where(adjusted_ASQTJ.gt.max_ASQTJ,max_ASQTJ,adjusted_ASQTJ)
    adjusted_AORGCJ  = where(adjusted_AORGCJ.gt.max_AORGCJ,max_AORGCJ,adjusted_AORGCJ)
    adjusted_APOCJ   = where(adjusted_APOCJ.gt.max_APOCJ,max_APOCJ,adjusted_APOCJ)
    adjusted_APOCI   = where(adjusted_APOCI.gt.max_APOCI,max_APOCI,adjusted_APOCI)
    adjusted_AOLGAJ  = where(adjusted_AOLGAJ.gt.max_AOLGAJ,max_AOLGAJ,adjusted_AOLGAJ)
    adjusted_AOLGBJ  = where(adjusted_AOLGBJ.gt.max_AOLGBJ,max_AOLGBJ,adjusted_AOLGBJ)
    adjusted_APNCOMJ = where(adjusted_APNCOMJ.gt.max_APNCOMJ,max_APNCOMJ,adjusted_APNCOMJ)
    adjusted_APNCOMI = where(adjusted_APNCOMI.gt.max_APNCOMI,max_APNCOMI,adjusted_APNCOMI)
    adjusted_APAH1J  = where(adjusted_APAH1J.gt.max_APAH1J,max_APAH1J,adjusted_APAH1J)
    adjusted_APAH2J  = where(adjusted_APAH2J.gt.max_APAH2J,max_APAH2J,adjusted_APAH2J)
    adjusted_APAH3J  = where(adjusted_APAH3J.gt.max_APAH3J,max_APAH3J,adjusted_APAH3J)
    adjusted_AOTHRJ  = where(adjusted_AOTHRJ.gt.max_AOTHRJ,max_AOTHRJ,adjusted_AOTHRJ)

    adjusted_AECJ    = where(adjusted_AECJ.gt.max_AECJ,max_AECJ,adjusted_AECJ)
    adjusted_AECI    = where(adjusted_AECI.gt.max_AECI,max_AECI,adjusted_AECI)

    adjusted_AFEJ    = where(adjusted_AFEJ.gt.max_AFEJ,max_AFEJ,adjusted_AFEJ)
    adjusted_AALJ    = where(adjusted_AALJ.gt.max_AALJ,max_AALJ,adjusted_AALJ)
    adjusted_ASIJ    = where(adjusted_ASIJ.gt.max_ASIJ,max_ASIJ,adjusted_ASIJ)
    adjusted_ATIJ    = where(adjusted_ATIJ.gt.max_ATIJ,max_ATIJ,adjusted_ATIJ)
    adjusted_ACAJ    = where(adjusted_ACAJ.gt.max_ACAJ,max_ACAJ,adjusted_ACAJ)
    adjusted_AMGJ    = where(adjusted_AMGJ.gt.max_AMGJ,max_AMGJ,adjusted_AMGJ)
    adjusted_AKJ    = where(adjusted_AKJ.gt.max_AKJ,max_AKJ,adjusted_AKJ)
    adjusted_AMNJ    = where(adjusted_AMNJ.gt.max_AMNJ,max_AMNJ,adjusted_AMNJ)
    adjusted_ACORS    = where(adjusted_ACORS.gt.max_ACORS,max_ACORS,adjusted_ACORS)
    adjusted_ASOIL    = where(adjusted_ASOIL.gt.max_ASOIL,max_ASOIL,adjusted_ASOIL)
    adjusted_ANAJ    = where(adjusted_ANAJ.gt.max_ANAJ,max_ANAJ,adjusted_ANAJ)
    adjusted_ACLI    = where(adjusted_ACLI.gt.max_ACLI,max_ACLI,adjusted_ACLI)
    adjusted_ACLJ    = where(adjusted_ACLJ.gt.max_ACLJ,max_ACLJ,adjusted_ACLJ)
    adjusted_ACLK    = where(adjusted_ACLK.gt.max_ACLK,max_ACLK,adjusted_ACLK)
    adjusted_ASEACAT    = where(adjusted_ASEACAT.gt.max_ASEACAT,max_ASEACAT,adjusted_ASEACAT)

    adjusted_PM10 = OI

end if ;DA_SPECIES
end if ;DA_SPECIES
end if ;DA_SPECIES 
end if ;DA_SPECIES 
end if ;DA_SPECIES 
end if ;DA_SPECIES 


;#write
CMAQ=addfile(input_file2, "w")

  if (DA_SPECIES .eq. "O3") then
    CMAQ->O3(DA_TIME,:,:,:)=(/adjusted_value/)
  else if (DA_SPECIES .eq. "CO") then
    CMAQ->CO(DA_TIME,:,:,:)=(/adjusted_value/)
  else if (DA_SPECIES .eq. "SO2") then 
    CMAQ->SO2(DA_TIME,:,:,:)=(/adjusted_value/)
  else if (DA_SPECIES .eq. "NO2") then
    CMAQ->NO2(DA_TIME,:,:,:)=(/adjusted_value/)
  else if (DA_SPECIES .eq. "AOD") then
    CMAQ->ASO4J(DA_TIME,:,:,:)=(/adjusted_ASO4J/)
    CMAQ->ASO4I(DA_TIME,:,:,:)=(/adjusted_ASO4I/)
    CMAQ->ANO3J(DA_TIME,:,:,:)=(/adjusted_ANO3J/)
    CMAQ->ANO3I(DA_TIME,:,:,:)=(/adjusted_ANO3I/)
    CMAQ->ANH4J(DA_TIME,:,:,:)=(/adjusted_ANH4J/)
    CMAQ->ANH4I(DA_TIME,:,:,:)=(/adjusted_ANH4I/)
    CMAQ->ANH4K(DA_TIME,:,:,:)=(/adjusted_ANH4K/)
    CMAQ->ANO3K(DA_TIME,:,:,:)=(/adjusted_ANO3K/)
    CMAQ->AECJ(DA_TIME,:,:,:)=(/adjusted_AECJ/)
    CMAQ->AECI(DA_TIME,:,:,:)=(/adjusted_AECI/)
    CMAQ->AALK1J(DA_TIME,:,:,:)=(/adjusted_AALK1J/)
    CMAQ->AALK2J(DA_TIME,:,:,:)=(/adjusted_AALK2J/)
    CMAQ->ABNZ1J(DA_TIME,:,:,:)=(/adjusted_ABNZ1J/)
    CMAQ->ABNZ2J(DA_TIME,:,:,:)=(/adjusted_ABNZ2J/)
    CMAQ->ATOL1J(DA_TIME,:,:,:)=(/adjusted_ATOL1J/)
    CMAQ->ABNZ3J(DA_TIME,:,:,:)=(/adjusted_ABNZ3J/)
    CMAQ->ATOL2J(DA_TIME,:,:,:)=(/adjusted_ATOL2J/)
    CMAQ->ATOL3J(DA_TIME,:,:,:)=(/adjusted_ATOL3J/)
    CMAQ->AXYL1J(DA_TIME,:,:,:)=(/adjusted_AXYL1J/)
    CMAQ->AXYL2J(DA_TIME,:,:,:)=(/adjusted_AXYL2J/)
    CMAQ->AXYL3J(DA_TIME,:,:,:)=(/adjusted_AXYL3J/)
    CMAQ->AOLGAJ(DA_TIME,:,:,:)=(/adjusted_AOLGAJ/)
    CMAQ->AISO1J(DA_TIME,:,:,:)=(/adjusted_AISO1J/)
    CMAQ->AISO2J(DA_TIME,:,:,:)=(/adjusted_AISO2J/)
    CMAQ->AISO3J(DA_TIME,:,:,:)=(/adjusted_AISO3J/)
    CMAQ->ATRP1J(DA_TIME,:,:,:)=(/adjusted_ATRP1J/)
    CMAQ->ATRP2J(DA_TIME,:,:,:)=(/adjusted_ATRP2J/)
    CMAQ->APAH1J(DA_TIME,:,:,:)=(/adjusted_APAH1J/)
    CMAQ->APAH2J(DA_TIME,:,:,:)=(/adjusted_APAH2J/)
    CMAQ->APAH3J(DA_TIME,:,:,:)=(/adjusted_APAH3J/)
    CMAQ->ASQTJ(DA_TIME,:,:,:)=(/adjusted_ASQTJ/)
    CMAQ->AOLGBJ(DA_TIME,:,:,:)=(/adjusted_AOLGBJ/)
    CMAQ->AORGCJ(DA_TIME,:,:,:)=(/adjusted_AORGCJ/)
    CMAQ->APOCI(DA_TIME,:,:,:)=(/adjusted_APOCI/)
    CMAQ->APOCJ(DA_TIME,:,:,:)=(/adjusted_APOCJ/)
    CMAQ->ANAJ(DA_TIME,:,:,:)=(/adjusted_ANAJ/)
    CMAQ->ACLJ(DA_TIME,:,:,:)=(/adjusted_ACLJ/)
    CMAQ->ACLI(DA_TIME,:,:,:)=(/adjusted_ACLI/)
    CMAQ->ASEACAT(DA_TIME,:,:,:)=(/adjusted_ASEACAT/)
    CMAQ->ACLK(DA_TIME,:,:,:)=(/adjusted_ACLK/)
    CMAQ->ASO4K(DA_TIME,:,:,:)=(/adjusted_ASO4K/)
    CMAQ->APNCOMI(DA_TIME,:,:,:)=(/adjusted_APNCOMI/)
    CMAQ->APNCOMJ(DA_TIME,:,:,:)=(/adjusted_APNCOMJ/)
    CMAQ->AOTHRJ(DA_TIME,:,:,:)=(/adjusted_AOTHRJ/)
    CMAQ->AALJ(DA_TIME,:,:,:)=(/adjusted_AALJ/)
    CMAQ->ACAJ(DA_TIME,:,:,:)=(/adjusted_ACAJ/)
    CMAQ->AFEJ(DA_TIME,:,:,:)=(/adjusted_AFEJ/)
    CMAQ->ASIJ(DA_TIME,:,:,:)=(/adjusted_ASIJ/)
    CMAQ->ATIJ(DA_TIME,:,:,:)=(/adjusted_ATIJ/)
    CMAQ->AMGJ(DA_TIME,:,:,:)=(/adjusted_AMGJ/)
    CMAQ->AKJ(DA_TIME,:,:,:)=(/adjusted_AKJ/)
    CMAQ->AMNJ(DA_TIME,:,:,:)=(/adjusted_AMNJ/)
    CMAQ->ACORS(DA_TIME,:,:,:)=(/adjusted_ACORS/)
    CMAQ->ASOIL(DA_TIME,:,:,:)=(/adjusted_ASOIL/)

  else if (DA_SPECIES .eq. "PM10") then
    CMAQ->AALK1J(DA_TIME,:,:,:)=(/adjusted_AALK1J/)
    CMAQ->AALK2J(DA_TIME,:,:,:)=(/adjusted_AALK2J/)
    CMAQ->AXYL1J(DA_TIME,:,:,:)=(/adjusted_AXYL1J/)
    CMAQ->AXYL2J(DA_TIME,:,:,:)=(/adjusted_AXYL2J/)
    CMAQ->AXYL3J(DA_TIME,:,:,:)=(/adjusted_AXYL3J/)
    CMAQ->ATOL1J(DA_TIME,:,:,:)=(/adjusted_ATOL1J/)
    CMAQ->ATOL2J(DA_TIME,:,:,:)=(/adjusted_ATOL2J/)
    CMAQ->ATOL3J(DA_TIME,:,:,:)=(/adjusted_ATOL3J/)
    CMAQ->ABNZ1J(DA_TIME,:,:,:)=(/adjusted_ABNZ1J/)
    CMAQ->ABNZ2J(DA_TIME,:,:,:)=(/adjusted_ABNZ2J/)
    CMAQ->ABNZ3J(DA_TIME,:,:,:)=(/adjusted_ABNZ3J/)
    CMAQ->ATRP1J(DA_TIME,:,:,:)=(/adjusted_ATRP1J/)
    CMAQ->ATRP2J(DA_TIME,:,:,:)=(/adjusted_ATRP2J/)
    CMAQ->AISO1J(DA_TIME,:,:,:)=(/adjusted_AISO1J/)
    CMAQ->AISO2J(DA_TIME,:,:,:)=(/adjusted_AISO2J/)
    CMAQ->AISO3J(DA_TIME,:,:,:)=(/adjusted_AISO3J/)
    CMAQ->ASQTJ(DA_TIME,:,:,:)=(/adjusted_ASQTJ/)
    CMAQ->AORGCJ(DA_TIME,:,:,:)=(/adjusted_AORGCJ/)
    CMAQ->APOCJ(DA_TIME,:,:,:)=(/adjusted_APOCJ/)
    CMAQ->APOCI(DA_TIME,:,:,:)=(/adjusted_APOCI/)
    CMAQ->AOLGAJ(DA_TIME,:,:,:)=(/adjusted_AOLGAJ/)
    CMAQ->AOLGBJ(DA_TIME,:,:,:)=(/adjusted_AOLGBJ/)
    CMAQ->APNCOMJ(DA_TIME,:,:,:)=(/adjusted_APNCOMJ/)
    CMAQ->APNCOMI(DA_TIME,:,:,:)=(/adjusted_APNCOMI/)
    CMAQ->APAH1J(DA_TIME,:,:,:)=(/adjusted_APAH1J/)
    CMAQ->APAH2J(DA_TIME,:,:,:)=(/adjusted_APAH2J/)
    CMAQ->APAH3J(DA_TIME,:,:,:)=(/adjusted_APAH3J/)
    CMAQ->AOTHRJ(DA_TIME,:,:,:)=(/adjusted_AOTHRJ/)

    CMAQ->AECJ(DA_TIME,:,:,:)=(/adjusted_AECJ/)
    CMAQ->AECI(DA_TIME,:,:,:)=(/adjusted_AECI/)

    CMAQ->AFEJ(DA_TIME,:,:,:)=(/adjusted_AFEJ/)
    CMAQ->AALJ(DA_TIME,:,:,:)=(/adjusted_AALJ/)
    CMAQ->ASIJ(DA_TIME,:,:,:)=(/adjusted_ASIJ/)
    CMAQ->ATIJ(DA_TIME,:,:,:)=(/adjusted_ATIJ/)
    CMAQ->ACAJ(DA_TIME,:,:,:)=(/adjusted_ACAJ/)
    CMAQ->AMGJ(DA_TIME,:,:,:)=(/adjusted_AMGJ/)
    CMAQ->AKJ(DA_TIME,:,:,:)=(/adjusted_AKJ/)
    CMAQ->AMNJ(DA_TIME,:,:,:)=(/adjusted_AMNJ/)
    CMAQ->ACORS(DA_TIME,:,:,:)=(/adjusted_ACORS/)
    CMAQ->ASOIL(DA_TIME,:,:,:)=(/adjusted_ASOIL/)
    CMAQ->ANAJ(DA_TIME,:,:,:)=(/adjusted_ANAJ/)
    CMAQ->ACLI(DA_TIME,:,:,:)=(/adjusted_ACLI/)
    CMAQ->ACLJ(DA_TIME,:,:,:)=(/adjusted_ACLJ/)
    CMAQ->ACLK(DA_TIME,:,:,:)=(/adjusted_ACLK/)
    CMAQ->ASEACAT(DA_TIME,:,:,:)=(/adjusted_ASEACAT/)
  end if
  end if
  end if
  end if
  end if
  end if

 
  if (DA_SPECIES .eq. "AOD") then
  output_AOD=CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
               +"_"+CMAQ_start+"_AOD_PM.nc"
  print(output_AOD)
  CMAQ_AOD=addfile(output_AOD, "w")
  CMAQ_AOD->AOD(DA_TIME,:,:)=(/adjusted_AOD/)
  CMAQ_AOD->AOD@_FillValue = -0.0009
  end if

  if (DA_SPECIES .eq. "PM10") then
  output_PM10=CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
               +"_"+CMAQ_start+"_AOD_PM.nc"
  print(output_PM10)
  CMAQ_PM10=addfile(output_PM10, "w")
  CMAQ_PM10->PM10(DA_TIME,:,:)=(/adjusted_PM10/)
  CMAQ_PM10->PM10@_FillValue = -0.0009
  end if
;****************************************************************************

end
