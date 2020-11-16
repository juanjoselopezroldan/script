#!/bin/bash
#----Enunciado----
#P13. Crea un script que escanee un equipo o un segmento de red y devuelva los puertos abiertos y los protocolos estándar que se ejecutan en ellos (sacado de /etc/services por ejemplo).
#Este script realiza un escaneo de un segmento de la red, ofreciendo la posibilidad de comrpobar si la herramienta a utilizar esta instalada y si no está
#que la instale siendo root, comprobando si tiene conexion con internet. Una vez realizada la anterior comprobacion, realiza el escaneo y una vez finalizado el escaneo, te permite
#conectarte a traves de ssh a una maquina que este dentro de esa red.

#FUNCIONES UTILIZADAS QUE SE DECRIBEN A CONTINUACION EN CADA APARTADO DEL SCRIPT

function comproot(){
	if [ `whoami` = "root" ]
	then
		pin=$(ping -c1 8.8.8.8 | grep "1 received")
		if [[ "$pin" != "" ]]
		then
			apt-get install nmap
		else
			echo "No tiene Conexion a la red, por favor comprueba tu conexion"
		fi
	else
			echo "Por favor, ejecuta esta aplicacion siendo root"
	fi			
}

function escaneored(){
	escaner=$(nmap "$ip/$masc")
	echo "$escaner"
}


#Primero realiza una validacion de que el usuario no haya metido ningun parametro en la ejecucion del script, si lo ha introducido no mandara un mesaje de error
#indicando que el usuario debe ejecutar el script de forma simple.
if [[ "$#" = 0 ]]
then
	echo "Desea escanear la red (si) o (no)"
	read opcion

	case $opcion
	in
	"si")
#Cuando le indicas que si quieres escanear la red, te comprobara con las siguientes lineas si tienes el paquete nmap instalado.
		comp=$(dpkg -s nmap | grep -o "Status: install ok installed")
		clear
		if [[ $comp != "Status: install ok installed" ]]
		then
			echo "La herramienta necesaria para el escaneo no esta instalada"
			echo "¿Desea instalarla?(si) o (no)"
			read instalar
#Si no esta instalada procedera a instalarla pero antes comprueba si esta como root con la funcion comproot, si está lo instala pero si no, se cierra el programa y te pide que lo ejecutes como root
#Acto seguido si estas como root, te comprobara si tiene conexion con internet para poder instalar el paquete, si tiene conexion lo instalará pero si no te pedira que compruebes tu conexion con la red
			case $instalar
			in
			"si")
				comproot
			;;
			"no")
				echo "Saliendo de la aplicacion"
			;;
			*)
				echo "Por favor, Introduce la opcion (SI) o (NO)"
			esac
		else
			echo "Introduce un rango para hacer el escaneo"
			read ip
#Una vez comprobado todos los parametros anteriores, procedera a pedir la direccion ip del rango que quieres escanear y posteriormente la mascara de red y procedera a realizar el escaneo
			if	[[ "$ip" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
			then
				echo "La direccion IP $ip es correcta"
				echo "Introduce la mascara de red"
				read masc
				echo "Ejecutando la aplicacion..."
#llamamos a la funcion para que escanee la red
				escaneored
			else
				echo "La direccion ip es incorrecta"
				echo "Reiniciando la aplicacion..."
				source escaneo.sh
		
			fi
#Una vez que se haya realizado el escaneo podremos hacer una conexion ssh a una maquina de la red
				echo "Desea conectarse por ssh a alguna ip deseada"
				while read peticion;
				do
					case $peticion in
					"si")
				
						echo "Introduce la direccion ip a la que desea conectarse (comprobaremos primero si existe conexion con esa direccion)"
#Introduciremos la ip y nos hará una validacion de dicha ip en cuanto al formato de longitud y si es correcto procedera a comprobar si existe conexion
#si existe conexion nos pedira un usuario del equipo remoto y su contraseña y conectara de forma remota, si no existe conexion procedera a notificarlo y saldra de la aplicacion

						while read ip2;
						do
							if	[[ "$ip2" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
							then
								echo "La direccion IP $ip2 es correcta"	

								comprobar=$(ping -c1 "$ip2" | grep "1 received")	
								if [[ "$comprobar" != "" ]]
								then
									echo "Existe Conexion"
									echo "Desea conectarse por SSH (si) o (no)"
									while read conexion
									do
										case $conexion
										in
										"si")
											read -p "Introduce el nombre del usuario (no sea Root) del equipo remoto con el que desea conectarse: " usuario	

											ssh "$usuario@$ip2"
											break
										;;
										"no")
											echo "Saliendo de la aplicacion"
											break

										;;
										*)
											echo "Por favor, introducir un valor (si o no)"

										esac
									done
								else
									echo "No Existe Conexion"
									echo "Saliendo de la aplicacion"
									break
								fi
								break
							else				
								echo "Error, el formato ip es incorrecto"
								echo "Introduce una direccion IP para conectarse"
							fi
						done
						break
					;;
					"no")
						echo "Saliendo de la aplicacion"
						break
					;;
					*)
						echo "Por favor, introducir un valor (si o no)"

					esac
				done
		fi
	;;
	"no")
		echo "Saliendo de la aplicacion"
	;;
	*)
		echo "Por favor, Introduce la opcion (SI) o (NO)"
		source escaneo.sh
	esac
else
	echo "Por favor no introduzca ningun valos en la linea de comandos, los parametros se introduce cuando se ejecute el script"
fi
