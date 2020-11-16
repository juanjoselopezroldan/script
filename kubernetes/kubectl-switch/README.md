# KUBECTL SWITCH

Plugin para Kubectl que permite la activación o desactivación de un entorno test para optimizar el coste de cluster.
Basicamente reduce a 0 el numero de replicas de un rc/deploy o lo sube a 1 replica en el caso de activarlo

Para añadir el plugin a kubectl, hay que seguir los siguientes pasos:

- Nos descargamos el plugin adjuntado en este correo.
- Acto seguido le asignamos el plugin los privilegios de ejecución:
```
chmod +x ./kubectl-switch
```
- Movemos el plugin a la ruta que aparece a continuación:
```
sudo mv ./kubectl-switch /usr/local/bin
```
- Una vez movido el plugin, ejecutaremos el siguiente comando para comprobar que ya se encuentra en nuestra lista de plugins:
```
kubectl plugin list
```
- Por último ya podremos disfrutar de nuestro bonito y práctico plugin:
```
kubectl switch
```
