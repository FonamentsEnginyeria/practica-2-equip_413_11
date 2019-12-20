# Práctica 2 Git

## Objetivo

En esta práctica  tendremos como objetivo trabajar y practicar el uso de un SCV ( Sistema de Control de Versiones ) llamado Git. También seguriemos desarrollando nuestras habilidades con el lenguaje de programación shellscript ( Bash ) y descubrir que nos ofrecen estas herramientas cuando las ponemos en práctica juntas.

En este caso seguiremos desarrolando el software que creamos anteriormente llamado FakeNetflix, por lo tanto nuestra rama master en git contendrá la versión final de la práctica 1 de FakeNetflix.
En la práctica 2, vamos a seguir desarrolando funciones para nuestro software de contenido multimedia y para ello usaremos Git para controlar y gestionar todas las modificaciones que hagamos.

Todo esto se hará en un repositorio de Git de forma local, pero también se irán subiendo los cambios a un repositorio remoto llamado GitHub que tendrá cada grupo de forma privada en esta plataforma.

En resumen, los objetivos principales de esta práctica serán los de aprender a usar Git en un entorno local y remoto, ser capaz de crear ramas ( branch ), juntarlas y gestionarlas y seguir adquiriendo agilidad con Git y Bash.

Por lo tanto, en esta práctica añadiremos cuatro funciones más al software, es decir, primero añadiremos cuatro opciones más al menu de nuestra aplicación, aún que en este caso hemos hecho que tanto la primera función como la segunda sean totalmente automáticas, por lo tanto solo se añadirán dos opciones más.

Por cada nueva función de nuestra aplicación tendremos cuatro ramas diferentes a master ( F1 - F4 ) para así desarrollar las cuatro funciones de forma separada y ordenada.

Cada vez que se acabe una función de forma correcta, se fusionará ( merge ) con la rama principal ( master ) y hacer push al repositorio remoto para que el compañero pueda hacer pull de los cambios realizados y poder modificarlo después.

## Funciones

La primera función es la de sincronización automática de contenidos.

Queremos actualizar el catálogo de los usuarios de forma automática así que nos piden que añadamos la opción de sincronización a nuestra aplicación, para ello, cada vez que arranque el programa se deberá comprobar si el archivo publicado es diferente del que tenemos guardado en local en nuestro repositorio, si la base de datos obetenida difiere de la que tenemos en nuestro repositorio, habrá que actualizar nuestro archivo local.

Para ello, se han usado principalmente dos comandos que podemos destacar:

* wget: este comando descarga en nuestro sistema el archivo que le indiquemos con la url.

* diff: el comando permite sacar la diferencia de contenido de dos archivos diferentes.

### Código

```synchronize_catalogue() {

	wget https://raw.githubusercontent.com/acocauab/practica2csv/master/test.csv
	diff -u netflix.csv test.csv | grep '^\+' | sed -E 's/^\+//' | tail +2 >> netflix.csv
	rm test.csv
	rm netflix_temp.csv	
}
```

En este caso, primero se usa el wget con el url del archivo con el nuevo contenido multimedia y se guarda en un archivo test.csv para sacar la información más adelante.

Para comprobar si hay alguna diferencia con el archivo que tenemos de forma local, se usa el diff que comparará el netflix.csv con el archivo que se ha descargado llamado test.csv. Las diferencias encontradas se añadiran al archivo de netflix.csv local.

### Problemas

En el caso de wget para que se descargase correctamente el archivo se debe añadir a la url "raw." al principio del todo, justo después de "https://" para que el archivo no se descargue html, ya que solo necesitamos el contenido de este.

Por otra parte tenemos a diff que también da probelmas, ya que el comando añade al output unas señalizaiónes que a nosotros no nos interesan a la hora de añadir el contenido a la base de datos y para ello se ha filtrado el contenido con los siguientes comandos:

```grep '^\+' | sed -E 's/^\+//' | tail +2
```


La segunda función crea directorios por cada año existente en la base de datos.



