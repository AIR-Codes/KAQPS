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
  start_t = stringtointeger(getenv("DA_TIME"))
  end_t   = stringtointeger(getenv("DA_TIME")) 
  print(start_t)
  print(end_t)

  START_DAY=stringtointeger(getenv("JULIAN_DA"))
  START_HOUR=stringtointeger(getenv("Tstep_DA"))
  END_DAY=stringtointeger(getenv("JULIAN_DA"))
  END_HOUR=stringtointeger(getenv("Tstep_DA"))
  print(START_DAY + " :: " + START_HOUR + " :: " + END_DAY + " :: " + END_HOUR)
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

AODPM_DATA=CMAQ_OUTPUT_PATH+"/cctm/CCTM_"+APPL_NAME+"_Linux2_x86_64"+compiler+".CONC."+CFG_NAME \
             +"_"+CMAQ_start+"_AOD_PM.nc"
AODPM=addfile(AODPM_DATA, "r")

MCIP_DIR = getenv("MCIP_OUTPUT_PATH")
MCIP_PATH = MCIP_DIR + "/METCRO3D_KORUS_AQ.nc"  
LATLON_PATH = MCIP_DIR + "/METCRO2D_KORUS_AQ.nc"
END_DAY=stringtointeger(getenv("JULIAN_DA"))
END_HOUR=stringtointeger(getenv("Tstep_DA"))
;****************************************************************************



;*** read input *************************************************************
print("start_t = " + start_t + " :: " + "end_t = " + end_t)
day=CCTM->TFLAG(start_t:end_t,0,0)
hr=CCTM->TFLAG(start_t:end_t,0,1)
print("day = " + day + " :: " + " hr = " + hr)

DA_SPECIES_f_AOD  = AODPM->AOD(start_t:end_t,:,:)
DA_SPECIES_f_PM10 = AODPM->PM10(start_t:end_t,:,:)
DA_SPECIES_f_PM25 = AODPM->PM25(start_t:end_t,:,:)

DA_SPECIES_f_O3  = CCTM->O3(start_t:end_t,0,:,:)
DA_SPECIES_f_NO2 = CCTM->NO2(start_t:end_t,0,:,:)
DA_SPECIES_f_CO  = CCTM->CO(start_t:end_t,0,:,:)
DA_SPECIES_f_SO2 = CCTM->SO2(start_t:end_t,0,:,:)
;****************************************************************************


;*** process & write output *************************************************
    hour = hr/10000
    hour_s = sprinti("%0.2i",hour)

    opt1 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_AOD.txt"
    opt1@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_AOD.txt"
    print(output)
    write_matrix (DA_SPECIES_f_AOD(0,:,:), "273f20.12", opt1) ;273,204

    opt2 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_O3.txt"
    opt2@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_O3.txt"
    print(output)
    write_matrix (DA_SPECIES_f_O3(0,:,:), "273f20.12", opt2) ;273,204

    opt3 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_NO2.txt"
    opt3@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_NO2.txt"
    print(output)
    write_matrix (DA_SPECIES_f_NO2(0,:,:), "273f20.12", opt3) ;273,204

    opt4 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_CO.txt"
    opt4@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_CO.txt"
    print(output)
    write_matrix (DA_SPECIES_f_CO(0,:,:), "273f20.12", opt4) ;273,204

    opt5 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_SO2.txt"
    opt5@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_SO2.txt"
    print(output)
    write_matrix (DA_SPECIES_f_SO2(0,:,:), "273f20.12", opt5) ;273,204

    opt6 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_PM10.txt"
    opt6@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_PM10.txt"
    print(output)
    write_matrix (DA_SPECIES_f_PM10(0,:,:), "273f20.12", opt6) ;273,204

    opt7 = True
    output = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_PM25.txt"
    opt7@fout = dir3+Tstep_num+"_CMAQoutput_"+day+hour_s+"_PM25.txt"
    print(output)
    write_matrix (DA_SPECIES_f_PM25(0,:,:), "273f20.12", opt7) ;273,204
;****************************************************************************

end



