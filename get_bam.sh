#! /bin/bash

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
        
        if [ -e /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}/BAM${dataanl}${yyyymmdd_prev}${hh}.grib2 ]
        then
          echo "BAM${dataanl}${yyyymmdd_prev}${hh}.grib2 existe"
        else
          echo "BAM${dataanl}${yyyymmdd_prev}${hh}.grib2 nao existe"
          wget -c http://ftp.cptec.inpe.br/modelos/io/tempo/global/BAM/${dataanl}/BAM${dataanl}${yyyymmdd_prev}${hh}.grib2
        fi

        if [ -e /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}/GPOSNMC${dataanl}${yyyymmdd_prev}${hh}P.grib2 ]
        then
          echo "GPOSNMC${dataanl}${yyyymmdd_prev}${hh}P.grib2 existe"
        else
          echo "GPOSNMC${dataanl}${yyyymmdd_prev}${hh}P.grib2 nao existe"
          wget -c http://ftp.cptec.inpe.br/modelos/io/tempo/global/BAM/${dataanl}/GPOSNMC${dataanl}${yyyymmdd_prev}${hh}P.grib2	
        fi

        if [ -e /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}/GPOSREG${dataanl}${yyyymmdd_prev}${hh}.grib2 ]
        then
          echo "GPOSREG${dataanl}${yyyymmdd_prev}${hh}.grib2 existe"
        else
          echo "GPOSREG${dataanl}${yyyymmdd_prev}${hh}.grib2 nao existe"
          wget -c http://ftp.cptec.inpe.br/modelos/io/tempo/global/BAM/${dataanl}/GPOSREG${dataanl}${yyyymmdd_prev}${hh}.grib2
        fi
        #sleep 4s
        
      done

      echo "${yyyymmdd_anl}"
      if [ -e /dados/dmdpesq/BAM_grib2/${yyyymm} ]
      then 
        echo "Diretorio ${yyyymm} Existe"
      else
        echo "Diretório Não existe. Vamos Criar o diretorio ${yyyymm}"
        mkdir /dados/dmdpesq/BAM_grib2/${yyyymm}
      fi

      if [ -e /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi} ]
      then
        echo "Diretório ${yyyymm}/${yyyymmdd_anl}${hhi} já Existe"
      else
        echo "Diretório Nao Existe. Vamos Criar o diretorio ${yyyymm}/${yyyymmdd_anl}${hhi}"
        mkdir /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}
      fi

      mv BAM${dataanl}*.grib2 /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}
      mv GPOSNMC${dataanl}*.grib2 /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}
      mv GPOSREG${dataanl}*.grib2 /dados/dmdpesq/BAM_grib2/${yyyymm}/${yyyymmdd_anl}${hhi}

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

