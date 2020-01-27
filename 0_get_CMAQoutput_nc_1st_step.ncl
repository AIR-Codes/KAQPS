;*** information of this code ***********************************************
; This code is created by Kyunghwa Lee (K.Lee)
;
; e-mail address: lkh1515@gmail.com 
;****************************************************************************

begin

;*** setting ****************************************************************
  setfileoption("nc","Format","LargeFile")
  AV_CONST = 6.0221415*10^23  ; Avogadro # (#/mol)
  R_CONST = 8.314472*10^6  ; Ideal Gas Constant (cm^3 Pa/K mol)
  AV_R = AV_CONST / R_CONST
  DU_R = 2.69*10^16  ; 1DU = 2.69*10^16 (#/cm2) 
  CMAQ_LAYER = 27

  Tstep=stringtointeger(getenv("t"))
  Tstep_num=getenv("OUTPUT_STEP")

  print(Tstep)
  print(Tstep_num)

  CMAQ_start = stringtointeger(getenv("sYEAR")+getenv("sMON")+getenv("sDAY"))

  Year_Mon = getenv("sYEAR")+"_"+getenv("sMON")

  set_end_step=getenv("set_end_step")
  print(Tstep + " :: " + stringtointeger(set_end_step) + " :: " + stringtointeger(getenv("DA_TIME")))

  if (Tstep .eq. stringtointeger(set_end_step) .and.stringtointeger(getenv("JULIAN_DA")) .eq. 2016165 .and. stringtointeger(getenv("DA_TIME")) .eq. 24) then
    start_t = stringtointeger(getenv("DA_TIME"))
    end_t   = 23 
    END_DAY=stringtointeger(getenv("sJULIAN"))
    END_HOUR=end_t
  else
    start_t = stringtointeger(getenv("DA_TIME"))
    end_t   = stringtointeger(getenv("DA_TIME")) 
    END_DAY=stringtointeger(getenv("JULIAN_DA"))
    END_HOUR=stringtointeger(getenv("Tstep_DA")) 
  end if
  START_DAY  = stringtointeger(getenv("sJULIAN"))
  START_HOUR = stringtointeger(getenv("sHOUR"))
  print(START_DAY + " :: " + START_HOUR + " :: " + END_DAY + " :: " + END_HOUR)
;****************************************************************************

;****************************************************************************
  C_WASO = (/4.05, 7.50, 7.63, 7.75, 7.88, 8.02, 8.15, 8.29, 8.43, 8.57, \
    8.71, 8.86, 9.01, 9.16, 9.31, 9.39, 9.47, 9.55, 9.64, 9.72, \
    9.80, 9.89, 9.97, 10.06, 10.15, 10.23, 10.32, 10.41, 10.50, 10.59, \
    10.68, 10.78, 10.87, 10.96, 11.06, 11.23, 11.41, 11.59, 11.77, 11.96, \
    12.15, 12.34, 12.54, 12.73, 12.94, 13.30, 13.68, 14.07, 14.48, 14.89, \
    15.31, 15.75, 16.20, 16.66, 17.13, 17.58, 18.03, 18.49, 18.97, 19.46, \
    21.17, 23.03, 25.05, 27.25/)
  C_WASO = C_WASO / C_WASO(0) * 3.0
  C_OC = (/3.34, 4.56, 4.60, 4.64, 4.68, 4.72, 4.76, 4.80, 4.84, 4.88, \
    4.92, 4.96, 5.00, 5.05, 5.09, 5.19, 5.30, 5.40, 5.51, 5.62, \
    5.74, 5.85, 5.97, 6.09, 6.21, 6.34, 6.47, 6.60, 6.73, 6.87, \
    7.01, 7.15, 7.29, 7.44, 7.59, 7.74, 7.89, 8.04, 8.20, 8.35, \
    8.52, 8.68, 8.85, 9.02, 9.20, 9.37, 9.54, 9.71, 9.89, 10.07, \
    10.25, 10.44, 10.63, 10.82, 11.02, 11.79, 12.62, 13.51, 14.46, 15.47, \
    17.91, 20.73, 24.00, 27.78/)
  C_OC = C_OC / C_OC(0) * 4.0
  C_EC = (/10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, \
    10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, \
    10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, 10.68, \
    10.68, 10.68, 10.68, 10.68, 10.68, 10.91, 11.14, 11.37, 11.61, 11.85, \
    12.10, 12.36, 12.62, 12.88, 13.15, 13.40, 13.65, 13.91, 14.17, 14.44, \
    14.71, 14.98, 15.27, 15.55, 15.84, 16.17, 16.50, 16.83, 17.18, 17.53, \
    17.53, 17.53, 17.53, 17.53/)
  C_EC = C_EC / C_EC(0) * 10.0
  C_SSA = (/1.87, 3.54, 3.61, 3.67, 3.73, 3.80, 3.86, 3.93, 4.00, 4.07, \
    4.14, 4.21, 4.29, 4.36, 4.44, 4.48, 4.53, 4.58, 4.63, 4.68, \
    4.73, 4.78, 4.84, 4.89, 4.94, 4.99, 5.05, 5.10, 5.16, 5.21, \
    5.27, 5.33, 5.39, 5.44, 5.50, 5.61, 5.72, 5.84, 5.95, 6.07, \
    6.19, 6.32, 6.44, 6.57, 6.70, 6.92, 7.16, 7.40, 7.64, 7.90, \
    8.17, 8.44, 8.72, 9.01, 9.32, 9.99, 10.71, 11.49, 12.32, 13.22, \
    16.72, 21.15, 26.75, 33.83/)
  C_SSA = C_SSA / C_SSA(0) * 1.37
  C_SSC = (/0.16, 0.33, 0.33, 0.34, 0.34, 0.35, 0.36, 0.36, 0.37, 0.38, \
    0.39, 0.39, 0.40, 0.41, 0.41, 0.42, 0.42, 0.43, 0.43, 0.44, \
    0.44, 0.45, 0.45, 0.46, 0.47, 0.47, 0.48, 0.48, 0.49, 0.49, \
    0.50, 0.50, 0.51, 0.52, 0.52, 0.53, 0.54, 0.56, 0.57, 0.58, \
    0.59, 0.60, 0.62, 0.63, 0.64, 0.66, 0.68, 0.70, 0.72, 0.74, \
    0.76, 0.78, 0.81, 0.83, 0.86, 0.90, 0.95, 1.00, 1.06, 1.12, \
    1.27, 1.45, 1.66, 1.89/)
  C_SSC = C_SSC / C_SSC(0) * 1.37
  M_DUST_J = 1.00
  M_DUST_K = 0.60
  RH_INDEX = array_append_record(0, ispan(37, 100, 1), 0)

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
;****************************************************************************

;*** input file path & name *************************************************
  CMAQ_OUTPUT_PATH = getenv("CMAQ_OUTPUT_PATH")
  converted_CMAQ_PATH = getenv("converted_CMAQ_PATH")
  APPL_NAME = getenv("APPL_NAME")

  dir2=CMAQ_OUTPUT_PATH+"/cctm/"
  dir3=converted_CMAQ_PATH+"/"
  CFG_NAME=getenv("CFG_NAME")
  compiler=getenv("compiler")
  input=dir2+"CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME+"_"+CMAQ_start+".nc"
  CCTM=addfile(input, "r")
  print(input)

  MCIP_DIR = getenv("MCIP_OUTPUT_PATH")
  MCIP_PATH = MCIP_DIR + "/METCRO3D_KORUS_AQ.nc"  
  LATLON_PATH = MCIP_DIR + "/METCRO2D_KORUS_AQ.nc"
;****************************************************************************



;*** read input *************************************************************
day=CCTM->TFLAG(:,0,0)
hr=CCTM->TFLAG(:,0,1)

DA_SPECIES = "AOD"

MCIP = addfile(MCIP_PATH, "r")  
MCIP_DAY = MCIP->TFLAG(:, 0, 0)
MCIP_HOUR = MCIP->TFLAG(:, 0, 1) * 1e-4
MCIP_START_IND = ind(MCIP_DAY.eq.START_DAY.and.MCIP_HOUR.eq.START_HOUR)
MCIP_END_IND = ind(MCIP_DAY.eq.END_DAY.and.MCIP_HOUR.eq.END_HOUR)

print(MCIP_START_IND + " :: " + MCIP_END_IND)
RH = wrf_rh(MCIP->QV(MCIP_START_IND:MCIP_END_IND, :, :, :), \
     MCIP->PRES(MCIP_START_IND:MCIP_END_IND, :, :, :), \
     MCIP->TA(MCIP_START_IND:MCIP_END_IND, :, :, :))
RH = where(RH.ge.99, 99, RH) ; change RH values .ge. 99 to 99

;PRES = MCIP->PRES(MCIP_START_IND:MCIP_END_IND, :, :, :)
;TA = MCIP->TA(MCIP_START_IND:MCIP_END_IND, :, :, :)

ZF = MCIP->ZF(MCIP_START_IND:MCIP_END_IND, :, :, :)
H = ZF
DATA_DIM = dimsizes(H)
  
do l = 1, DATA_DIM(1) - 1
  
  H(:, l, :, :) = ZF(:, l, :, :) - ZF(:, l - 1, :, :)
  
end do

H_cm = H * 100 ; m => cm

;DA_SPECIES_f = DA_SPECIES(:,0,:,:)

  if (DA_SPECIES .eq. "AOD") then
    AERODIAM_PATH =  dir2 + "CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".AERODIAM."+CFG_NAME+"_"+CMAQ_start+".nc"
    AERODIAM = addfile(AERODIAM_PATH,"r")

    AERODIAM_DAY = AERODIAM->TFLAG(:, 0, 0)
    AERODIAM_HOUR = AERODIAM->TFLAG(:, 0, 1) * 1e-4
    AERODIAM_START_IND = ind(AERODIAM_DAY.eq.START_DAY.and.AERODIAM_HOUR.eq.START_HOUR)
    AERODIAM_END_IND = ind(AERODIAM_DAY.eq.END_DAY.and.AERODIAM_HOUR.eq.END_HOUR)
    print(AERODIAM_START_IND + " :: " + AERODIAM_END_IND)

    if(ismissing(AERODIAM_START_IND)) then
      AERODIAM_START_IND = 0
    end if
    print(AERODIAM_START_IND + " :: " + AERODIAM_END_IND)

    PM25AT = new((/dimsizes(CCTM->CO(:,0,0,0)),dimsizes(CCTM->CO(0,0,:,0)),dimsizes(CCTM->CO(0,0,0,:))/),"float")
    PM25AC = new((/dimsizes(CCTM->CO(:,0,0,0)),dimsizes(CCTM->CO(0,0,:,0)),dimsizes(CCTM->CO(0,0,0,:))/),"float")
    PM25CO = new((/dimsizes(CCTM->CO(:,0,0,0)),dimsizes(CCTM->CO(0,0,:,0)),dimsizes(CCTM->CO(0,0,0,:))/),"float")

    PM25AT(0,:,:) = AERODIAM->PM25AT(0,0,:,:)
    PM25AC(0,:,:) = AERODIAM->PM25AC(0,0,:,:)
    PM25CO(0,:,:) = AERODIAM->PM25CO(0,0,:,:)

    PM25AT(1:,:,:) = AERODIAM->PM25AT(AERODIAM_START_IND:AERODIAM_END_IND,0,:,:)
    PM25AC(1:,:,:) = AERODIAM->PM25AC(AERODIAM_START_IND:AERODIAM_END_IND,0,:,:)
    PM25CO(1:,:,:) = AERODIAM->PM25CO(AERODIAM_START_IND:AERODIAM_END_IND,0,:,:)


    WASO_MEE = where(RH.ge.RH_INDEX(0).and.RH.lt.RH_INDEX(1), C_WASO(0), -999)
    OM_MEE = where(RH.ge.RH_INDEX(0).and.RH.lt.RH_INDEX(1), C_OC(0), -999)
    EC_MEE = where(RH.ge.RH_INDEX(0).and.RH.lt.RH_INDEX(1), C_EC(0), -999)
    SSA_MEE = where(RH.ge.RH_INDEX(0).and.RH.lt.RH_INDEX(1), C_SSA(0), -999)
    SSC_MEE = where(RH.ge.RH_INDEX(0).and.RH.lt.RH_INDEX(1), C_SSC(0), -999)
            
    
  do i = 1, dimsizes(RH_INDEX) - 2
    
    WASO_MEE = where(RH.ge.RH_INDEX(i).and.RH.lt.RH_INDEX(i + 1), \
      C_WASO(i), WASO_MEE)
    OM_MEE = where(RH.ge.RH_INDEX(i).and.RH.lt.RH_INDEX(i + 1), \
      C_OC(i), OM_MEE)
    EC_MEE = where(RH.ge.RH_INDEX(i).and.RH.lt.RH_INDEX(i + 1), \
      C_EC(i), EC_MEE)
    SSA_MEE = where(RH.ge.RH_INDEX(i).and.RH.lt.RH_INDEX(i + 1), \
      C_SSA(i), SSA_MEE)
    SSC_MEE = where(RH.ge.RH_INDEX(i).and.RH.lt.RH_INDEX(i + 1), \
      C_SSC(i), SSC_MEE)
      
  end do    
  
    WASO_AOD = (/ZF/) * 0
    OM_AOD = WASO_AOD
    EC_AOD = WASO_AOD
    SSA_AOD = WASO_AOD
    SSC_AOD = WASO_AOD      
    DUST_J_AOD = WASO_AOD
    DUST_K_AOD = WASO_AOD

  ; ############### WASO AOD #############  

    do i = 0, dimsizes(WASO) - 1
  
      WASO_AOD = WASO_AOD + CCTM->$WASO(i)$(:, :, :, :)
    
    end do
     
    do i = 0, dimsizes(WASO_K) - 1
  
      WASO_AOD = WASO_AOD + CCTM->$WASO_K(i)$(:, :, :, :)
    
    end do
  
    WASO_AOD = WASO_AOD * H * WASO_MEE * 1e-6


  ; ############### OM AOD #############
    do i = 0, dimsizes(OM) - 1
  
      OM_AOD = OM_AOD + CCTM->$OM(i)$(:, :, :, :)
    
    end do
  
    OM_AOD = OM_AOD * OM_MEE * H * 1e-6   

  ; ############### EC AOD #############  

    do i = 0, dimsizes(EC) - 1
  
      EC_AOD = EC_AOD + CCTM->$EC(i)$(:, :, :, :)
    
    end do
  
    EC_AOD = EC_AOD * EC_MEE * H * 1e-6
    
  ; ############### SSA AOD #############    
    do i = 0, dimsizes(SSA) - 1
  
      SSA_AOD = SSA_AOD + CCTM->$SSA(i)$(:, :, :, :)
    
    end do  
  
    SSA_AOD = SSA_AOD * SSA_MEE * H * 1e-6  


  ; ############### SSC AOD #############    

    do i = 0, dimsizes(SSC) - 1
  
      SSC_AOD = SSC_AOD + CCTM->$SSC(i)$(:, :, :, :)
    
    end do

    SSC_AOD = SSC_AOD * SSC_MEE * H * 1e-6  

  ; ############### DUST_J AOD #############    
  
    do i = 0, dimsizes(DUST_J) - 1

      DUST_J_AOD = DUST_J_AOD + CCTM->$DUST_J(i)$(:, :, :, :)
    
    end do
  
    DUST_J_AOD = DUST_J_AOD * M_DUST_J * H * 1e-6
  
    ; ############### DUST_K AOD #############    

    do i = 0, dimsizes(DUST_K) - 1

      DUST_K_AOD = DUST_K_AOD + CCTM->$DUST_K(i)$(:, :, :, :)
    
    end do
  
    DUST_K_AOD = DUST_K_AOD * M_DUST_K * H * 1e-6

    AOD = dim_sum_n(WASO_AOD + OM_AOD + EC_AOD + SSA_AOD + SSC_AOD + \
        DUST_J_AOD + DUST_K_AOD, 1)
    DA_SPECIES_f = AOD


   ; ### for PM ###________________________________________________________

  PM_I = (/"ASO4I", "ANH4I", "ANO3I", "ACLI", "AECI", "APOCI", "APNCOMI"/)
  PM_J = (/"ASO4J", "ANH4J", "ANO3J", "AALK1J", "AALK2J", "AXYL1J", "AXYL2J", \
           "AXYL3J", "ATOL1J", "ATOL2J", "ATOL3J", "ABNZ1J", "ABNZ2J", "ABNZ3J", \
           "ATRP1J", "ATRP2J", "AISO1J", "AISO2J", "AISO3J", "ASQTJ", "AORGCJ", \
           "APOCJ", "AOLGAJ", "AOLGBJ", "APNCOMJ",  "APAH1J", \
           "APAH2J", "APAH3J", "AOTHRJ", "AFEJ", "AALJ", "ASIJ", "ATIJ", "ACAJ", \
           "AMGJ", "AKJ", "AMNJ", "AECJ", "ANAJ", "ACLJ"/)
  PM_K = (/"ANO3K", "ANH4K", "ASO4K", "ACORS", "ASOIL", "ACLK", "ASEACAT"/)

  DIME= CCTM->ASO4I(:, 0, :, :)
  PM_I_CONC = (/DIME/) * 0
  PM_J_CONC = PM_I_CONC
  PM_K_CONC = PM_I_CONC




; ############### PM_I_CONC #############  
  do i = 0, dimsizes(PM_I) - 1
  
    PM_I_CONC = PM_I_CONC + CCTM->$PM_I(i)$(:, 0, :, :)
    
  end do


; ############### PM_J_CONC #############  
  do i = 0, dimsizes(PM_J) - 1
  
    PM_J_CONC = PM_J_CONC + CCTM->$PM_J(i)$(:, 0, :, :)
    
  end do


; ############### PM_K_CONC #############  
  do i = 0, dimsizes(PM_K) - 1
  
    PM_K_CONC = PM_K_CONC + CCTM->$PM_K(i)$(:, 0, :, :)
    
  end do

; ############### PM2.5 & PM10 #############    
  PM10 = PM_I_CONC + PM_J_CONC + PM_K_CONC
  PM25 = PM_I_CONC * PM25AT + PM_J_CONC * PM25AC + PM_K_CONC * PM25CO


;*** process & write output *************************************************
  PM10!0 = "TSTEP"
  PM10!1 = "ROW"
  PM10!2 = "COL"
  PM25!0 = "TSTEP"
  PM25!1 = "ROW"
  PM25!2 = "COL"

  output_AOD=CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
               +"_"+CMAQ_start+"_"+DA_SPECIES+"_PM.nc"
  print(output_AOD)
  CMAQ_AOD=addfile(output_AOD, "c")
  CMAQ_AOD->AOD=DA_SPECIES_f
  CMAQ_AOD->AOD!0 = "TSTEP"
  CMAQ_AOD->AOD!1 = "ROW"
  CMAQ_AOD->AOD!2 = "COL"
  CMAQ_AOD->AOD@_FillValue = -0.0009

  CMAQ_AOD->PM10=PM10
  CMAQ_AOD->PM10@_FillValue = -0.0009

  CMAQ_AOD->PM25=PM25
  CMAQ_AOD->PM25@_FillValue = -0.0009
;****************************************************************************

  end if
;****************************************************************************

end



