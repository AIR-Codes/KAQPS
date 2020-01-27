#!/bin/csh -f
###################################################################################
# Description of this code: this code has been developed by Kyunghwa Lee (K.Lee), #
#                           so email to lkh1515@gmail.com                         #
#                           if you have any question.                             #
###################################################################################

### t while loop start ###..............................................
setenv t $set_start_step
while ($t <= $set_end_step)

  echo "===<exp_name>======================================"
  setenv OUTPUT_STEP "Tstep_"$t
  echo "@" ${OUTPUT_STEP}"................................"
  if ($t > 1) then
  set Tstep_CTM_1 = $t
  @ Tstep_CTM_1 = $Tstep_CTM_1 - 1
  setenv CTM_1_PATH ${OUTPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_OUTPUT/CMAQ_${CFG_NAME}/Tstep_${Tstep_CTM_1}
  echo ${CTM_1_PATH}
  endif

  setenv TIME_DURATION_1st 23  
  setenv DA_TIME_1st ${TIME_DURATION_1st}
  setenv TIME_DURATION_other 24
  setenv DA_TIME_other ${TIME_DURATION_other}

  if ($t == 1) then
    setenv DA_TIME $DA_TIME_1st
    setenv TIME_DURATION $TIME_DURATION_1st
  else
    setenv DA_TIME $DA_TIME_other
    setenv TIME_DURATION $TIME_DURATION_other
  endif

  if ($sHOUR1 == 1 || $sHOUR1 == 01) then
    @ time_lag_s = 23
    @ time_lag_e = 24
  else
    @ time_lag_s = $DA_TIME
    @ time_lag_e = $DA_TIME
  endif

  echo "time_lag_s="$time_lag_s
  echo "time_lag_e="$time_lag_e

  echo "[RUN] TIME_DURATION="$TIME_DURATION
  echo "[DA] DA_TIME="$DA_TIME

## Set run time
  setenv BeYEAR `printf %04d $sYEAR1`
  setenv BeMONTH `printf %02d $sMON1`
  setenv BeDAY `printf %02d $sDAY1`


  if ($t == 1) then
  @ sHOUR1 = $sHOUR1
  @ eHOUR1 = $eHOUR1 
  else 
  @ sHOUR1 = $sHOUR1 + $time_lag_s
  @ eHOUR1 = $eHOUR1 + $time_lag_e 
  endif


  if ($sHOUR1 == 24) then
  @ sDAY1 = $sDAY1 + 1 
  @ sJULIAN_D = $sJULIAN_D + 1 
  @ sHOUR1 = 00 
  else if ($sHOUR1 > 24 ) then
  @ sDAY1 = $sDAY1 + 1 
  @ sJULIAN_D = $sJULIAN_D + 1 
  @ sHOUR1 = $sHOUR1 - 24 
  endif

  if ($eHOUR1 == 24) then
  @ eDAY1 = $eDAY1 + 1 
  @ eJULIAN_D = $eJULIAN_D + 1 
  @ eHOUR1 = 00 
  else if ($eHOUR1 > 24 ) then
  @ eDAY1 = $eDAY1 + 1 
  @ eJULIAN_D = $eJULIAN_D + 1 
  @ eHOUR1 = $eHOUR1 - 24 
  endif

  @ s_remainder = $sMON1 % 2

  if ($sMON1 <= 7 && $s_remainder == 0) then
   set temp_end = 31
  else if ($sMON1 <= 7 && $s_remainder == 1) then
   set temp_end = 32
  else if ($sMON1 > 7 && $s_remainder == 0) then
   set temp_end = 32
  else if ($sMON1 > 7 && $s_remainder == 1) then
   set temp_end = 31
  endif

  if ($sMON1 == 2 && $sYEAR1 == 2014) then
   set temp_end = 29
  else if ($sMON1 == 2 && $sYEAR1 == 2015) then
   set temp_end = 29
  else if ($sMON1 == 2 && $sYEAR1 == 2016) then
   set temp_end = 30
  endif

  if ($sDAY1 == $temp_end) then
    @ sMON1 = $sMON1 + 1
    set sDAY1 = 1
  endif

  if ($sMON1 == 13) then
    @ sYEAR1 = $sYEAR1 + 1
    set sMON1 = 1
  endif


  @ e_remainder = $eMON1 % 2

  if ($eMON1 <= 7 && $e_remainder == 0) then
   set temp_end = 31
  else if ($eMON1 <= 7 && $e_remainder == 1) then
   set temp_end = 32
  else if ($eMON1 > 7 && $e_remainder == 0) then
   set temp_end = 32
  else if ($eMON1 > 7 && $e_remainder == 1) then
   set temp_end = 31
  endif

  if ($eMON1 == 2 && $eYEAR1 == 2014) then
   set temp_end = 29
  else if ($eMON1 == 2 && $eYEAR1 == 2015) then
   set temp_end = 29
  else if ($eMON1 == 2 && $eYEAR1 == 2016) then
   set temp_end = 30
  endif

  if ($eDAY1 == $temp_end) then
    @ eMON1 = $eMON1 + 1
    set eDAY1 = 1
  endif

  if ($eMON1 == 13) then
    @ eYEAR1 = $eYEAR1 + 1
    set eMON1 = 1
  endif

## Set time step to conduct data assimilation
  setenv Tstep_DA `printf %02d $eHOUR1`
  setenv Dstep_DA `printf %02d $eDAY1`
  setenv Mstep_DA `printf %02d $eMON1`
  setenv Ystep_DA `printf %04d $eYEAR1`

  setenv RUN_DA ${DA_RUN}

  echo "[DA] Ystep_DA="$Ystep_DA, "Mstep_DA="$Mstep_DA, "Dstep_DA="$Dstep_DA, "Tstep_DA="$Tstep_DA
  setenv YYMMDDTT $Ystep_DA$Mstep_DA$Dstep_DA$Tstep_DA

  setenv sYEAR `printf %04d $sYEAR1`
  setenv eYEAR `printf %04d $eYEAR1`

  setenv sMON `printf %02d $sMON1`
  setenv eMON `printf %02d $eMON1`

  setenv sDAY `printf %02d $sDAY1`
  setenv eDAY `printf %02d $eDAY1`

  setenv sHOUR `printf %02d $sHOUR1`
  setenv eHOUR `printf %02d $eHOUR1`


## Check run time in Julian calendar
  if ($Ystep_DA == 2004 && $Ystep_DA == 2008 && $Ystep_DA == 2012 && $Ystep_DA == 2016 && $Ystep_DA == 2020) then  
    set n_days_year_DA = 366    # <- leap years
  else
    set n_days_year_DA = 365
  endif


## Check run time
  echo "[CMAQ RUN] sYEAR="$sYEAR, "sMON="$sMON, "sDAY="$sDAY, "sHOUR="$sHOUR
  echo "[CMAQ RUN] eYEAR="$eYEAR, "eMON="$eMON, "eDAY="$eDAY, "eHOUR="$eHOUR

## Check run time in Julian calendar
  if ($sYEAR1 == 2004 && $sYEAR1 == 2008 && $sYEAR1 == 2012 && $sYEAR1 == 2016 && $sYEAR1 == 2020) then  
  # leap years
    set n_days_year = 366
  else
    set n_days_year = 365
  endif

  if ($sJULIAN_D > $n_days_year) then
  @ sJULIAN_D = 001 
  endif
  if ($eJULIAN_D > $n_days_year) then
  @ eJULIAN_D = 001 
  endif

  setenv sJULIAN `printf %04d $sYEAR1``printf %03d $sJULIAN_D`
  setenv eJULIAN `printf %04d $eYEAR1``printf %03d $eJULIAN_D`
  echo "[CMAQ RUN] sJULIAN="$sJULIAN, "eJULIAN="$eJULIAN

  setenv JULIAN_DA `printf %04d $eYEAR1``printf %03d $eJULIAN_D`
  echo "[DA] JULIAN_DA="$JULIAN_DA

## Check run_BE time
  echo "[RUN_BE_time for icon]" "YEAR_BE="$BeYEAR, "MONTH_BE="$BeMONTH, "DAY_BE="$BeDAY

mkdir -p ${INPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_WRFinput/
mkdir -p ${CMAQ_WRFinput_PATH}
mkdir -p ${CMAQ_WRFinput_PATH}/GEOGRID
mkdir -p ${CMAQ_WRFinput_PATH}/METGRID


#************** Let's start CMAQ *****************************************************
setenv CMAQ_OUTPUT_PATH ${OUTPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_OUTPUT/CMAQ_${CFG_NAME}/${OUTPUT_STEP}
setenv CMAQ_OUTPUT_logfiles ${OUTPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_OUTPUT/CMAQ_${CFG_NAME}/${OUTPUT_STEP}/log_files_${exp_name}


### MCIP______________________________________________________________
if ($RUN_MCIP < 1) then
 echo MCIP

mkdir -p ${MCIP_DATA_PATH}
mkdir -p ${MCIP_OUTPUT_PATH}

## Back up the previous output
mkdir -p ${MCIP_OUTPUT_PATH}/backup_be
mkdir -p ${MCIP_OUTPUT_PATH}/backup_be/MCIP_be
mkdir -p ${MCIP_OUTPUT_PATH}/backup_be/log_files
mv ${MCIP_OUTPUT_PATH}/* ${MCIP_OUTPUT_PATH}/backup_be/MCIP_be >&/dev/null
mv ${MCIP_OUTPUT_PATH}/run_logfiles/run_KORUS-AQ.mcip.log ${MCIP_OUTPUT_PATH}/backup_be/log_files >&/dev/null
mkdir -p ${MCIP_OUTPUT_PATH}/run_logfiles

cp ${OP_CODE}/run_KORUS-AQ.mcip ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|M3HOME|${M3HOME}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|MCIP_DATA_PATH|${MCIP_DATA_PATH}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|MCIP_HOME|${MCIP_HOME}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|CMAQ_WRFinput_PATH|${CMAQ_WRFinput_PATH}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|MCIP_OUTPUT_PATH|${MCIP_OUTPUT_PATH}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|GEOGRID_PATH|${GEOGRID_PATH}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|MCIP_TIME_INTVL|${MCIP_TIME_INTVL}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|REF_LAT_WRF_CMAQ|${REF_LAT_WRF_CMAQ}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|NCOLS_CMAQ|${NCOLS_CMAQ}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|NROWS_CMAQ|${NROWS_CMAQ}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|WRF_OUTPUT_FOR_MCIP|${WRF_OUTPUT_FOR_MCIP}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|RUN_GRID_NAME|${RUN_GRID_NAME}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip


## Set run time
sed -i "s|sYEAR|${sYEAR}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|sMON|${sMON}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|sDAY|${sDAY}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|sHOUR|${sHOUR}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|eYEAR|${eYEAR}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|eMON|${eMON}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|eDAY|${eDAY}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip
sed -i "s|eHOUR|${eHOUR}|g" ${MCIP_HOME}/run_KORUS-AQ.mcip


## Run MCIP
cd ${MCIP_HOME}
mkdir -p ${MCIP_OUTPUT_PATH}/run_logfiles 
chmod 755 run_KORUS-AQ.mcip
time ./run_KORUS-AQ.mcip >& ${MCIP_OUTPUT_PATH}/run_logfiles/run_KORUS-AQ.mcip.log

echo
else
 echo "MCIP wasn't operated!"
endif
#_____________________________________________________________________ 



### BUILD CMAQ________________________________________________________
if ($BUILD_CMAQ < 1) then
 echo BUILD_bldmake
cd $M3HOME/scripts/build
mkdir -p ${CMAQ_OUTPUT_logfiles}/bld_log
./bldit.bldmake >& ${CMAQ_OUTPUT_logfiles}/bld_log/bldit_bldmake.log
else
 echo "CMAQ wasn't built (or it is already built)!"
endif
#_____________________________________________________________________


### RUN CMAQ__________________________________________________________
## Start CMAQ
set EMISSION_FILE_NAME = EMIS_K-AQ_HC.nc

if ($RUN_CMAQ < 1) then
 echo CMAQ

## Back up the previous output
mkdir -p ${OUTPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_OUTPUT
mkdir -p ${OUTPUT_CMAQ_HARD}/KORUS_AQ_CMAQ_OUTPUT/CMAQ_${CFG_NAME}
mkdir -p ${CMAQ_OUTPUT_PATH}
mkdir -p ${CMAQ_OUTPUT_PATH}/backup_be
mkdir -p ${CMAQ_OUTPUT_logfiles}
cd ${CMAQ_OUTPUT_PATH}/backup_be
rm -rf ${CMAQ_OUTPUT_PATH}/backup_be/* >&/dev/null
cd ${CMAQ_OUTPUT_PATH}
mv ${CMAQ_OUTPUT_PATH}/icon backup_be >&/dev/null
mv ${CMAQ_OUTPUT_PATH}/bcon backup_be >&/dev/null
mv ${CMAQ_OUTPUT_PATH}/cctm backup_be >&/dev/null
mv ${CMAQ_OUTPUT_PATH}/jproc backup_be >&/dev/null

### For MOZART boundary condition
mkdir -p ${CMAQ_OUTPUT_PATH}/bcon
#ln -s ${BCON_PATH}${BCON_MOZART} /DATA/KLEE/KORUS_AQ/KORUS_AQ_CMAQ_OUTPUT/CMAQ_BASE_wBC/Tstep_1/bcon
#scp ${BCON_PATH}${BCON_MOZART} ${CMAQ_OUTPUT_PATH}/bcon
ln -s ${BCON_PATH}${BCON_MOZART} ${CMAQ_OUTPUT_PATH}/bcon

## Back up the previous logfile
mkdir -p ${CMAQ_OUTPUT_logfiles}/backup_be
mv ${OP_CODE}/02_CMAQ_wBC.log ${CMAQ_OUTPUT_logfiles}/backup_be >&/dev/null
mv ${CMAQ_OUTPUT_logfiles}/*.log ${CMAQ_OUTPUT_logfiles}/backup_be >&/dev/null
#mv ${CMAQ_OUTPUT_logfiles}/*.log ${CMAQ_OUTPUT_logfiles}/backup_be >&/dev/null


## Prepare necessary files to run
# 1) config.cmaq
cp ${OP_CODE}/config.cmaq ${M3HOME}/scripts/config.cmaq
sed -i "s|MCIP_DATA_PATH|${MCIP_DATA_PATH}|g" ${M3HOME}/scripts/config.cmaq
chmod 755 ${M3HOME}/scripts/config.cmaq
source ${M3HOME}/scripts/config.cmaq

# 2) icon
if ($t == 1) then
  cp ${OP_CODE}/bldit_KORUS-AQ_profile.icon ${M3HOME}/scripts/icon/bldit_KORUS-AQ.icon
  cp ${OP_CODE}/run_KORUS-AQ_profile.icon ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
else
  cp ${OP_CODE}/bldit_KORUS-AQ_m3conc.icon ${M3HOME}/scripts/icon/bldit_KORUS-AQ.icon
  cp ${OP_CODE}/run_KORUS-AQ_m3conc.icon ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|CTM_1_PATH|${CTM_1_PATH}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|sJULIAN|${sJULIAN}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|sHOUR|${sHOUR}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon

## Set run time
  sed -i "s|sYEAR|${sYEAR}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|sMON|${sMON}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|sDAY|${sDAY}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon

## Set run_BE time
  sed -i "s|BeYEAR|${BeYEAR}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|BeMONTH|${BeMONTH}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
  sed -i "s|BeDAY|${BeDAY}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
endif

#cp ${OP_CODE}/bldit_KORUS-AQ_profile.icon ${M3HOME}/scripts/icon/bldit_KORUS-AQ.icon
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${M3HOME}/scripts/icon/bldit_KORUS-AQ.icon

#cp ${OP_CODE}/run_KORUS-AQ_profile.icon ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
sed -i "s|RUN_GRID_NAME|${RUN_GRID_NAME}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
sed -i "s|CFG_NAME|${CFG_NAME}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
sed -i "s|CMAQ_OUTPUT_PATH|${CMAQ_OUTPUT_PATH}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon
sed -i "s|MCIP_APPL|${MCIP_APPL}|g" ${M3HOME}/scripts/icon/run_KORUS-AQ.icon


# 3) bcon
cp ${OP_CODE}/bldit_KORUS-AQ_wBC.bcon ${M3HOME}/scripts/bcon/bldit_KORUS-AQ_wBC.bcon
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${M3HOME}/scripts/bcon/bldit_KORUS-AQ_wBC.bcon

cp ${OP_CODE}/run_KORUS-AQ_wBC.bcon ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|RUN_GRID_NAME|${RUN_GRID_NAME}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|CFG_NAME|${CFG_NAME}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|CMAQ_OUTPUT_PATH|${CMAQ_OUTPUT_PATH}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|MCIP_APPL|${MCIP_APPL}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|sJULIAN|${sJULIAN}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|sHOUR|${sHOUR}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|TIME_DURATION|${TIME_DURATION}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|CTM_CONC_1_BCON|${CTM_CONC_1_BCON}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon
sed -i "s|BCON_MOZART|${BCON_MOZART}|g" ${M3HOME}/scripts/bcon/run_KORUS-AQ_wBC.bcon

# 4) cctm
cp ${OP_CODE}/bldit_KORUS-AQ.cctm ${M3HOME}/scripts/cctm/bldit_KORUS-AQ.cctm
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${M3HOME}/scripts/cctm/bldit_KORUS-AQ.cctm

if ($t == 1) then
cp ${OP_CODE}/run_KORUS-AQ_profile_wBC.cctm ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
else
cp ${OP_CODE}/run_KORUS-AQ_m3conc_wBC.cctm ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
endif

${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|MCIP_APPL|${MCIP_APPL}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|APPL_NAME|${APPL_NAME}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|sJULIAN|${sJULIAN}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|RUN_GRID_NAME|${RUN_GRID_NAME}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|EMISSION_PATH|${EMISSION_PATH}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|EMISSION_FILE_NAME|${EMISSION_FILE_NAME}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|OCEAN_FILE_NAME|${OCEAN_FILE_NAME}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|CFG_NAME|${CFG_NAME}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|DATA_etc_PATH|${DATA_etc_PATH}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|TIME_DURATION|${TIME_DURATION}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|SERIAL_OR_MPI|${SERIAL_OR_MPI}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|MPI_RUN|${MPI_RUN}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|NPCOL_NUM|${NPCOL_NUM}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|NPROW_NUM|${NPROW_NUM}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|BCON_MOZART|${BCON_MOZART}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm

## Set run time
sed -i "s|sYEAR|${sYEAR}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|sMON|${sMON}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|sDAY|${sDAY}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|sHOUR|${sHOUR}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm

## Set species & its vertical layers to conduct CMAQ
sed -i "s|CMAQ_CONC_SPECIES|${CMAQ_CONC_SPECIES}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|CMAQ_CONC_BLEV_ELEV|${CMAQ_CONC_BLEV_ELEV}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|CMAQ_AVG_CONC_SPCS|${CMAQ_AVG_CONC_SPCS}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm
sed -i "s|CMAQ_ACONC_BLEV_ELEV|${CMAQ_ACONC_BLEV_ELEV}|g" ${M3HOME}/scripts/cctm/run_KORUS-AQ.cctm

## Move scripts for the last step
  cd ${M3HOME}/scripts
  mkdir -p backup_be
  rm -rf backup_be/temp  >&/dev/null
  mkdir -p backup_be/temp
  mkdir -p backup_be/temp
  mkdir -p backup_be/temp/icon
  mkdir -p backup_be/temp/bcon
  mkdir -p backup_be/temp/jproc
  mkdir -p backup_be/temp/cctm
  mv ${M3HOME}/scripts/icon/BLD_${APPL_NAME} backup_be/temp/icon >&/dev/null
  mv ${M3HOME}/scripts/bcon/BLD_${APPL_NAME} backup_be/temp/bcon >&/dev/null
  mv ${M3HOME}/scripts/jproc/BLD_${APPL_NAME} backup_be/temp/jproc >&/dev/null
  mv ${M3HOME}/scripts/cctm/BLD_${APPL_NAME} backup_be/temp/cctm >&/dev/null


## Build & Run
cd ${OP_CODE}
time ./02_CMAQ_wBC.csh >& ${CMAQ_OUTPUT_logfiles}/02_CMAQ_wBC_${CFG_NAME}.log
else
 echo "CMAQ wasn't operated!"
endif


## Backup scripts for this step
  cd ${M3HOME}/scripts
  mkdir -p backup_be
  mkdir -p backup_be/${OUTPUT_STEP}
  mkdir -p backup_be/${OUTPUT_STEP}/icon
  mkdir -p backup_be/${OUTPUT_STEP}/bcon
  mkdir -p backup_be/${OUTPUT_STEP}/jproc
  mkdir -p backup_be/${OUTPUT_STEP}/cctm
  mv ${M3HOME}/scripts/icon/BLD_${APPL_NAME} backup_be/${OUTPUT_STEP}/icon >&/dev/null
  mv ${M3HOME}/scripts/bcon/BLD_${APPL_NAME} backup_be/${OUTPUT_STEP}/bcon >&/dev/null
  mv ${M3HOME}/scripts/jproc/BLD_${APPL_NAME} backup_be/${OUTPUT_STEP}/jproc >&/dev/null
  mv ${M3HOME}/scripts/cctm/BLD_${APPL_NAME} backup_be/${OUTPUT_STEP}/cctm >&/dev/null
  endif
#_____________________________________________________________________ 


### Data assimilation_________________________________________________
mkdir -p ${DA_PATH}
mkdir -p ${DA_PATH}/converted_CMAQoutput
mkdir -p $converted_CMAQ_PATH

  if ($RUN_DA < 1) then
   echo "Data Assimilation"
  mkdir -p ${DA_PATH_OUTPUT_F}
  mkdir -p ${CMAQ_OUTPUT_PATH}/cctm/CONC_before >&/dev/null

## Back up the previous logfile
  mkdir -p ${DA_logfile_PATH}
  mkdir -p ${DA_logfile_PATH}/backup_logfiles
  mv ${DA_logfile_PATH}/${OUTPUT_STEP}*.log ${DA_logfile_PATH}/backup_logfiles  >&/dev/null


## Back up the previous output files
  cd ${DA_PATH}
  mkdir -p ${DA_PATH}/converted_CMAQoutput/backup_be
  mv ${DA_PATH}/converted_CMAQoutput/${OUTPUT_STEP}*.* converted_CMAQoutput/backup_be  >&/dev/null
  mkdir -p ${DA_PATH_OUTPUT_F}/backup_be
output/backup_be  >&/dev/null
  mv ${DA_PATH_OUTPUT_F}/${OUTPUT_STEP}*.* output/backup_be  >&/dev/null


  mkdir -p ${DA_PATH}/logfiles_${exp_name}
  mkdir -p ${DA_logfile_PATH}
  mkdir -p ${DA_logfile_PATH}/backup_logfiles
  cd ${DA_PATH}
  ncl ./0_get_CMAQoutput_nc_1st_step.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_0.log
    echo "   AOD and PM are calculated!"


## Copy the cctm file of the previous time step
  cd ${CMAQ_OUTPUT_PATH}/cctm
  scp CCTM_${APPL_NAME}_Linux2_x86_64${compiler}.CONC.${CFG_NAME}_${sYEAR}${sMON}${sDAY} CONC_before

  cd ${DA_PATH}
  ncl ./1_get_CMAQoutput.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_1.log
  echo "   DA_1 is done!"


### CO
  setenv DA_SPECIES_f CO
  setenv SFC_DA_INPUT ${converted_CMAQ_PATH}'/'${OUTPUT_STEP}'_CMAQoutput_'${JULIAN_DA}${Tstep_DA}'_'${DA_SPECIES_f}'.txt'

  cd ${DA_PATH}
  f95 -mcmodel=large 2_interpolation_OBS+CMAQ_OI.f90 sortingFun.f90
  ./a.out  >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_2_${DA_SPECIES_f}.log

  setenv DA_FINAL_INPUT ${DA_PATH_OUTPUT_F}'/'${OUTPUT_STEP}'_OBS+CMAQ_OI_'${DA_SPECIES_f}'_'${YYMMDDTT}'_f.txt'
  echo "   DA_2 for SFC CO is done!"

  cd ${DA_PATH}
  ncl ./3_OBS+CMAQ_OI_3D_adjust.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_3_${DA_SPECIES_f}.log
  echo "   DA_3 for CO is done!"

### SO2
  setenv DA_SPECIES_f SO2
  setenv SFC_DA_INPUT ${converted_CMAQ_PATH}'/'${OUTPUT_STEP}'_CMAQoutput_'${JULIAN_DA}${Tstep_DA}'_'${DA_SPECIES_f}'.txt'

  cd ${DA_PATH}
  f95 -mcmodel=large 2_interpolation_OBS+CMAQ_OI.f90 sortingFun.f90
  ./a.out  >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_2_${DA_SPECIES_f}.log

  setenv DA_FINAL_INPUT ${DA_PATH_OUTPUT_F}'/'${OUTPUT_STEP}'_OBS+CMAQ_OI_'${DA_SPECIES_f}'_'${YYMMDDTT}'_f.txt'
  echo "   DA_2 for SFC SO2 is done!"

  cd ${DA_PATH}
  ncl ./3_OBS+CMAQ_OI_3D_adjust.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_3_${DA_SPECIES_f}.log
  echo "   DA_3 for SO2 is done!"

### O3
  setenv DA_SPECIES_f O3
  setenv SFC_DA_INPUT ${converted_CMAQ_PATH}'/'${OUTPUT_STEP}'_CMAQoutput_'${JULIAN_DA}${Tstep_DA}'_'${DA_SPECIES_f}'.txt'

  cd ${DA_PATH}
  f95 -mcmodel=large 2_interpolation_OBS+CMAQ_OI.f90 sortingFun.f90
  ./a.out  >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_2_${DA_SPECIES_f}.log

  setenv DA_FINAL_INPUT ${DA_PATH_OUTPUT_F}'/'${OUTPUT_STEP}'_OBS+CMAQ_OI_'${DA_SPECIES_f}'_'${YYMMDDTT}'_f.txt'
  echo "   DA_2 for SFC O3 is done!"

  cd ${DA_PATH}
  ncl ./3_OBS+CMAQ_OI_3D_adjust.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_3_${DA_SPECIES_f}.log
  echo "   DA_3 for O3 is done!"

if ( -f $GOCI_PATH'/collocated_GOCI_AOD_'$YYMMDDTT'.txt' ) then
  setenv DA_SPECIES_f AOD
  echo GOCI AOD file exists for $YYMMDDTT

  setenv SFC_DA_INPUT ${converted_CMAQ_PATH}'/'${OUTPUT_STEP}'_CMAQoutput_'${JULIAN_DA}${Tstep_DA}'_'${DA_SPECIES_f}'.txt'

  cd ${DA_PATH}
  f95 -mcmodel=large 2_interpolation_OBS+CMAQ_OI.f90 sortingFun.f90
  ./a.out  >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_2_${DA_SPECIES_f}.log
  echo "   DA_2 for AOD is done!"

  cd ${DA_PATH}
  ncl ./2-2_GOCI+CMAQ_AOD_reallocation_to_get_PM.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_2-2_${DA_SPECIES_f}.log
  echo "   DA_2-2 for AOD is done!"

  setenv DA_SPECIES_f PM10
  setenv SFC_DA_INPUT ${DA_PATH_OUTPUT_F}'/'${OUTPUT_STEP}'_adjusted_'${DA_SPECIES_f}'_from_GOCI+CMAQ_AOD_'${YYMMDDTT}'_f.txt'
else
  echo GOCI AOD file does not exist for $YYMMDDTT

### PM10
  setenv DA_SPECIES_f PM10
  setenv SFC_DA_INPUT ${converted_CMAQ_PATH}'/'${OUTPUT_STEP}'_CMAQoutput_'${JULIAN_DA}${Tstep_DA}'_'${DA_SPECIES_f}'.txt'
endif

  setenv DA_SPECIES_f PM10
  cd ${DA_PATH}
  f95 -mcmodel=large 2_interpolation_OBS+CMAQ_OI.f90 sortingFun.f90
  ./a.out  >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_2_${DA_SPECIES_f}.log

  setenv DA_FINAL_INPUT ${DA_PATH_OUTPUT_F}'/'${OUTPUT_STEP}'_OBS+CMAQ_OI_'${DA_SPECIES_f}'_'${YYMMDDTT}'_f.txt'
  echo "   DA_2 for SFC PM10 is done!"

  cd ${DA_PATH}
  ncl ./3_OBS+CMAQ_OI_3D_adjust.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_3_${DA_SPECIES_f}.log
  echo "   DA_3 for PM10 is done!"

  cd ${DA_PATH}
  ncl ./4_AOD_PM25_from_OI_DATA.ncl >& ${DA_logfile_PATH}/${OUTPUT_STEP}_DA_4_${DA_SPECIES_f}.log
  echo "   DA_4 for PM10 is done!"

  else
    echo "DA wasn't conducted!"
  endif
#_____________________________________________________________________ 

  echo   
  echo
  @ t = $t + 1
end 
### while loop end for t ###................................................

  echo   

exit()

