#!/bin/bash
echo "Desea escanear los puertos de la red"
read opcion

case $opcion
in
"si")

	comp=$(dpkg -s nmap | grep -o "Status: install ok installed")
	clear
	if [[ $comp != "Status: install ok installed" ]]
	then
		echo "La herramienta necesaria para el escaneo no esta instalada"
		echo "¿Desea instalarla?"
		read instalar

		case $instalar
		in
		"si")
			if [ `whoami` = "root" ]
			then
				apt-get install nmap
			else
				echo "Por favor, ejecuta esta aplicacion siendo root"
			fi
			
		;;
		"no")
			echo "Saliendo de la aplicacion"
		;;
		*)
			echo "Por favor, Introduce la opcion (SI) o (NO)"
		esac
	else
		echo "Introduce una direccion IP para hacer el escaneo"
		while read ip;
		do
			if	[[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
			then
				echo "La direccion IP $ip es correcta"
				echo "Introduce la mascara de red"
				read masc
				echo "Ejecutando la aplicacion..."
				escaner=$(nmap "$ip/$masc")
				echo "$escaner"
				break
			else
				echo "La direccion ip es incorrecta"
				echo "Introduce una direccion IP para hacer el escaneo"
			
			fi
		done
	fi
;;
"no")

;;
*)
	echo "Por favor, Introduce la opcion (SI) o (NO)"
	source escaneo.sh

esac

