#! /bin/bash

#inctime=/dados/dmdpesq/BAM_grib2/bin/inctime
inctime=/dados/dmdpesq/Proj_GFS/bin/inctime/inctime

getGrib() {

  #inctime analise
  fct=24

  #inctime dataprev
  tfct=${1}
 

  for hhi in $(seq -w 0 12 12)
  do
    datai=${2}${hhi}
    dataf=${3}${hhi}
    #echo "${datai}"


    data=${datai}

    while [ ${data} -le ${dataf} ]
    do

      yyyymm=$(echo ${data} | cut -c 1-6)
      yyyymmdd_anl=$(echo ${data} | cut -c 1-8)

      #echo ${data}
      dataanl=${data}
      for hh in $(seq -w 0 6 18)
      do
        dataprev=$(${inctime} ${dataanl} +${tfct}hr %y4%m2%d2%h2)
        yyyymmdd_prev=$(echo ${dataprev} | cut -c 1-8)
        echo "$hh"
        echo "analise $dataanl"
        echo "previsao $dataprev"
        

        ###wget -c http://ftp.cptec.inpe.br/modelos/io/tempo/global/BAM/${dataanl}/BAM${dataanl}${yyyymmdd_prev}${hh}.grib2
        ###wget -c http://ftp.cptec.inpe.br/modelos/io/tempo/global/BAM/${dataanl}/GPOSNMC{dataanl}${yyyymmdd_prev}${hh}P.grib2	
        ###wget -c http://ftp.cptec.inpe.br/modelos/io/tempo/global/BAM/${dataanl}/GPOSREG{dataanl}${yyyymmdd_prev}${hh}.grib2
        #sleep 4s
        #echo "${yyyymm}"
        #echo "${yyyymm}/${yyyymmdd}"
        #echo "movendo arquivo BAM${data}${yyyymmdd}${hh}.grib2 para /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl} "
        
      done
      #echo "${yyyymmdd_anl}/${tfct}"
      #mkdir /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}
      #mkdir /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}/${tfct}
      #mv *.grib2 /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}/${tfct}

      data=$(${inctime} ${data} +${fct}hr %y4%m2%d2%h2)

    done
  done
}

date=$(date +'%Y%m%d')
datef=$(date -d ' +1 days' '+%Y%m%d')
echo "$date"
echo "$datef"
for previsao in $(seq 24 24 168)
do 
    echo "*****************"
    echo "$previsao"
    echo "*****************"
    getGrib ${previsao} ${date} ${datef}
done

exit 0

