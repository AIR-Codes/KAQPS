#!/bin/csh -f
###################################################################################
# Description of this code: this code has been developed by Kyunghwa Lee (K.Lee), #
#                           so email to lkh1515@gmail.com                         #
#                           if you have any question.                             #
###################################################################################

### Option choosing steps to run______________________________________
#*** Do you wanna run steps selectively? (YES=0, NO=1) ***

## MCIP
setenv RUN_MCIP 1

## CMAQ
setenv BUILD_CMAQ 0
setenv RUN_CMAQ 0

## DA
setenv DA_RUN 0
#_____________________________________________________________________

## Start time_________________________________________________________
setenv sYEAR1 2016
setenv sMON1 4
setenv sDAY1 26
setenv sHOUR1 01

setenv eYEAR1 2016
setenv eMON1 4
setenv eDAY1 27
setenv eHOUR1 0
#_____________________________________________________________________


### Setting___________________________________________________________
setenv compiler pgi

## Set starting point
setenv set_start_step 1

## Set time steps to run CMAQ
setenv set_end_step 48

## experiment name (output folder name)
setenv exp_name HY_non

## Which species do you want to get as output from CMAQ?
setenv DA_SPECIES ALL   #<- ALL includes CO,SO2,NO2,O3,AOD
setenv OP_CODE_HARD /media//KORUS_AQ
setenv OUTPUT_CMAQ_HARD /media/KORUS_AQ
setenv INPUT_CMAQ_HARD /media/KORUS_AQ
setenv OBS_HARD /media/DATA
setenv BCON_HARD /media/KORUS_AQ
setenv MCIP_INPUT_HARD /media/KORUS_AQ
#_____________________________________________________________________


### Set time & REF_LAT________________________________________________
## Set reference latitude for WRF & CMAQ to match with emission data
setenv REF_LAT_WRF_CMAQ 33.0

## Set cases for CMAQ runs
setenv RUN_cases 1

## Set variables for scripts
setenv APPL_NAME KORUS_AQ
setenv MCIP_APPL KORUS_AQ
setenv CFG_NAME DA_HYBRID_non
setenv RUN_GRID_NAME KORUS-AQ_15
setenv OCEAN_FILE_NAME OCEAN_KORUS_AQ.nc
setenv SERIAL_OR_MPI mpi    #<- serial or mpi
setenv MPI_RUN 48    ; #<- Set # of precessors for mpi (=NPCOL_NUM * NPROW_NUM) 
setenv NPCOL_NUM 8
setenv NPROW_NUM 6
#_____________________________________________________________________

### MCIP______________________________________________________________
setenv MCIP_TIME_INTVL 60
setenv X0_MCIP 10
setenv Y0_MCIP 10
setenv NCOLS_CMAQ 273
setenv NROWS_CMAQ 204
#_____________________________________________________________________


### Set environment___________________________________________________
setenv OP_CODE ${OP_CODE_HARD}/MAIN_v5.1_ip54
setenv M3HOME /home/air/CMAQv5.1
setenv WRF_OUTPUT_FOR_MCIP ${INPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_WRFinput/combined_WRFoutput/combined_wrfout.nc
setenv MCIP_HOME ${M3HOME}/scripts/mcip
setenv MCIP_DATA_PATH ${MCIP_INPUT_HARD}/KORUS_AQ_CMAQ_OUTPUT/MCIP
setenv MCIP_OUTPUT_PATH ${MCIP_INPUT_HARD}/KORUS_AQ_CMAQ_OUTPUT/MCIP
setenv EMISSION_PATH ${INPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_INPUT/EMIS
setenv DATA_etc_PATH ${INPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_INPUT/data_KORUS_AQ
setenv CTM_EMLAYS 1  # <- when # of layer of the emission data is "1"!! If you don't set this environment, you will see an error message to match the # of layers of WRF output with the # of layers of emission data.

### Set environment for DA
setenv DA_PATH ${OP_CODE_HARD}/INTERPOLATION/OI_HYBRID_w_PM10_DA
setenv DA_PATH_OUTPUT ${OP_CODE_HARD}/INTERPOLATION/OI_HYBRID_w_PM10_DA/output_${exp_name}
setenv DA_PATH_OUTPUT_F ${OP_CODE_HARD}/INTERPOLATION/OI_HYBRID_w_PM10_DA/output_${exp_name}_F
setenv DA_logfile_PATH ${DA_PATH}/logfiles_${exp_name}
setenv converted_CMAQ_PATH ${DA_PATH}/converted_CMAQoutput
setenv MOPITT_PATH ${OBS_HARD}/Satellite/MOPITT/collocated_MOPITT_txt
setenv GOME2B_PATH ${OBS_HARD}/Satellite/GOME2/GOME2B/collocated_GOME2B_txt_ppm
setenv OMI_PATH ${OBS_HARD}/Satellite/OMI/OMI_sfc_conc_usingCMAQratio_txt_ppm
setenv GOCI_PATH ${OBS_HARD}/Satellite/GOCI/KORUS-AQ/collocated_GOCI
setenv AERONET_PATH ${OBS_HARD}/AERONET/collocated_AERONET
setenv AERONET_ORI_PATH ${OBS_HARD}/AERONET/rearranged_AERONET
#_____________________________________________________________________

### Run_______________________________________________________________
chmod 755 *.csh
./KAQPSv1.csh
#_____________________________________________________________________


exit()



