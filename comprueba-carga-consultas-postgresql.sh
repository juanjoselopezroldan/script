#!/bin/bash
# En este script se realiza una comprobación del estado de las consultas de postgresql a traves del comando ps -aux y si sobrepasa el limite, enviará un correo al cliente informandolo

original=$( ps -aux | grep "postgres" | grep -v idle )

#echo $original
pid=$( echo "$original" | awk {'print $2'} )
cpu=$( echo "$original" | awk {'print $3'} | cut -d "." -f 1 )
tiempo=$( echo "$original" | awk {'print $10'} | cut -d ":" -f 1 )
contador=0
contador1=0
contador2=0

for lineas in $tiempo
do
        echo $lineas
        echo "-"
        contador=$(expr $contador + 1)

        if [[ "$lineas" -gt "15" ]]; then
                for lineas2 in $cpu
                do
                        echo $lineas2
                        contador1=$(expr $contador1 + 1)
                        if [[ "lineas2" -gt "50" ]] && [[ "$contador" == "$contador1" ]]; then
                                for lineas3 in $pid
                                do
                                        echo $lineas3
                                        contador2=$(expr $contador2 + 1)
                                        if [[ "$contador" == "$contador2" ]]; then
                                                query=psql -c "SELECT query FROM pg_stat_activity where pid=$lineas3;"
                                                mail -s "PID: $lineas3 con la consulta: $query" correo@mail.com
                                        fi
                                done
                        fi
                done
        fi

done

echo $contador
echo $contador1
echo $contador2
