#! /bin/bash

inctime=/dados/dmdpesq/Proj_GFS/bin/inctime/inctime

#BAM20191110122019111100.grib2
#BAM 2019111012 2019111100.grib2
#46:37910776:d=2019111012:APCP:surface:12 hour fcst:
#
#GPOSNMC 2019111012 2019111100P.grib2
#124:91903669:d=2019111012:APCP:surface:24 hour fcst:
#
#GPOSREG 2019111012 2019111100.grib2
#205:166533798:d=2019111012:APCP:surface:12 hour fcst:



    
gribs=GFS
#pre inctime
fct=24
#previ file gfs
tfct=24 
i=12 


rm /dados/dmdpesq/BAM_grib2/etapa1/12/*
rm /dados/dmdpesq/BAM_grib2/etapa2/12/*
rm /dados/dmdpesq/BAM_grib2/etapa3/12/${tfct}/*
rm /dados/dmdpesq/BAM_grib2/etapa4/12/${tfct}/*


var=APCP

datef=$(date -d ' +1 days' '+%Y%m%d')
date=$(date -d ' -4 days' '+%Y%m%d')

datai=${date}${i}
dataf=${datef}18

data=${datai}
while [ ${data} -le ${dataf} ]
do
        yyyymm=$(echo ${data} | cut -c 1-6)
        ddhh=$(echo ${data} | cut -c 7-10)
        hh=$(echo ${data} | cut -c 9-10)
        dataanl=${data}

        echo "data analise ${dataanl}"

        #echo "${hh}"
        #echo "${yyyymm}/${ddhh}"

        dataprev=$(${inctime} ${dataanl} +${tfct}hr %y4%m2%d2%h2)

        echo "data previsao ${dataprev}"
        yyyymmdd_prev=$(echo ${dataprev} | cut -c 1-8)

        fileout_acumula=etapa1/${hh}/BAM.t${i}z.f${tfct}.anl${dataanl}.prev${yyyymmdd_prev}_${var}.grib2
        #fileout_acumula=etapa1/${hh}/gfs.t${hh}z.pgrb2f${tfct}.${dataanl}_${1}.grib2
    for temp in $(seq -w 0 6 18)
    do
        echo "***${temp}"
        arq_prev=${yyyymm}/${dataanl}/BAM${dataanl}${yyyymmdd_prev}${temp}.grib2
        echo "arquivo inicial ${arq_prev}"
        #arq_prev=${gribs}/${yyyymm}/${ddhh}/gfs.t${hh}z.pgrb2f${temp}.${dataanl}.grib2
        ##Extrai a variavel
        echo "Fileout ${fileout_acumula}"
        ~/bin/wgrib2 $arq_prev -append -match "(:${var}:)" -grib  $fileout_acumula

    done

    fileout_nc=etapa2/${hh}/BAM.t${i}z.f${tfct}.anl${dataanl}.prev${yyyymmdd_prev}_${var}.grib2.nc #:TMP:surface:
    echo "**********************************"
    echo "Converte arquivo grib2 para netcdf"
    echo "**********************************"
    ~/bin/wgrib2 $fileout_acumula -netcdf ${fileout_nc}

    #dataprev=$(${inctime} ${dataanl} +${fct}hr %y4%m2%d2%h2)
    #dataprev=$(${inctime} ${dataanl} +${tfct}hr %y4%m2%d2%h2)

    echo "************************************"
    echo "Calcular a somar dos passos de tempo"
    echo "************************************"
    cdo timselsum,28,0 ${fileout_nc} etapa3/${i}/${tfct}/BAM.t${i}z.f${tfct}.prev${yyyymmdd_prev}_${var}.grib2.nc
    	    

    data=$(${inctime} ${data} +${fct}hr %y4%m2%d2%h2)
done
#Juntar várias arquivos com váriáveis diferente em um único arquivo
