#!/bin/bash
echo Introduce una direccion IP para hacer ping
read ip

if	[[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
then
	echo "La direccion IP $ip es correcta"

	comprobar=$(ping -c1 "$ip" | grep "1 received")
	if [[ "$comprobar" != "" ]]
	then
		echo "Existe Conexion"
		echo "Desea conectarse por SSH"
		read conexion

		case $conexion
		in
		"si")
			read -p "Introduce el nombre del usuario con el que desea conectase: " usuario

			ssh "$usuario@$ip"
		;;
		"no")
			echo "Saliendo de la aplicacion"
		;;
		*)
			echo "Por favor, introducir un valor (si o no)"
		esac

	else
		echo "No Existe Conexion"
	fi
else
	echo "Error, el formato ip es incorrecto"
fi
