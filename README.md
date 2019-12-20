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

## La primera función es la de sincronización automática de contenidos.

Queremos actualizar el catálogo de los usuarios de forma automática así que nos piden que añadamos la opción de sincronización a nuestra aplicación, para ello, cada vez que arranque el programa se deberá comprobar si el archivo publicado es diferente del que tenemos guardado en local en nuestro repositorio, si la base de datos obetenida difiere de la que tenemos en nuestro repositorio, habrá que actualizar nuestro archivo local.

Para ello, se han usado principalmente dos comandos que podemos destacar:

* wget: este comando descarga en nuestro sistema el archivo que le indiquemos con la url.

* diff: el comando permite sacar la diferencia de contenido de dos archivos diferentes.

### Código

```
synchronize_catalogue() {

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

```
grep '^\+' | sed -E 's/^\+//' | tail +2
```


## La segunda función crea directorios por cada año existente en la base de datos.

Se genera un directorio por cada año en el que haya alguna película en la base de datos, es decir, por ejemplo si en nuestra base de datos hay tres películas con los años 2000, 2007 y 1998, entonces se crearán tres directorios respectivamente y dentro de estos un archivo .csv con las películas que salieron en ese año ( en este caso solo tendríamos una en cada archivo ). Cada directorio se creará con el nombre del año y dentro de este habrá el archivo .csv de todas las películas que salieron ese año, este archivo se llamará como el archivo original de la base de datos pero añadiendo un guion y el año de las películas que estamos almacenando ( en este caso sería "2000-netflix.csv".

No tenemos comandos destacados para esta función.

### Código

```
create_year_dir() {	

	#Crea un archivo con todos los años del csv original.
	awk -F ',' '{if($5 !="release_year")print $5}' $file_name > years_dirs.csv

	#Comprueba si los directorios existen
	printf "Aquí va la comprobación."

	#Filtra todos los años para que no se repitan.
	sort years_dirs.csv | uniq > sort_years_dir.csv
	rm years_dirs.csv
	mv sort_years_dir.csv years_dirs.csv

	#Crea los directorios de los años que hay en el csv de años filtrados.
	#Falta comprobar si existe.
	mkdir $(<years_dirs.csv)
	
	#Abre el archivo 
	#Mientras hay linias pilla la fila
	#De esa fila haces un awk mirando si ese valor coincide con alguna
	#pelicula que tenga ese año lo lleva al directorio de la variable y así con todos.
	while IFS= read -r line
	do
  		awk -F ',' '{if($5=='$line') print $0}' $file_name >> $line/$line-netflix.csv
	done < years_dirs.csv

	rm years_dirs.csv
}
```

Crea un archivo con todos los años del csv original. Comprueba si los directorios existen. Filtra todos los años para que no se repitan. Crea los directorios de los años que hay en el csv de años filtrados. Abre el archivo, mientras hay linias selecciona la fila, de esa fila haces un awk mirando si ese valor coincide con alguna pelicula que tenga ese año y lo lleva al directorio de la variable y así con todos los años.

### Problemas

En este caso no había problema alguno, únicamente puden existir errores a la hora de crear algún directorio ya que el usuario puede introducir variables que no sean números en la casilla de año y por lo tanto si escribe el nombre de un directorio existente, no se creará.


## La tercera función da de alta nuevas películas ( registros ).

Cada usuario debe poder añadir películas nuevas a la base de datos local de la aplicación y esta debe estar en una opción en el menú.

CUando se seleccione la opción, se le pedirá a l usuario que rellene todos los campos que debe tener una película para ser introducida en la base de datos correctamente.

Una vez se sincronize un nuevo catálogo, estos cambios se verán eliminados.


No tenemos comandos destacados para esta función.

### Código

```
#Permite añadir un nuevo registro al csv.
add_new_register() {

	file_exist

	printf "Nom de la pel·lícula [title]: "
	read title

	printf "Rating de la de la pel·lícula [rating]: "
	read rating
	
	printf "Descripció del rating de la pel·lícula [rating score]: "
	read rating_description

	printf "Nivell de rating de la pel·lícula [rating level]: "
	read rating_level
	
	printf "Any de publicació de la pel·lícula [release year]: "
	read release_year

	printf "Valoració de la pel·lícula [user rating score]: "
	read user_rating_score

	printf "User rating size de la pel·lícula [user rating size]: "
	read user_rating_size

	#Con todos los años pedidos inserta los datos en la base de datos temporal.
	printf "$title,$rating,$rating_description,$rating_level,$release_year,$user_rating_score,$user_rating_size\n" >> netflix_temp.csv

}
```

### Problemas - Descripción del código

Esta función era muy sencilla y no ha dado probelmas, únicamente consistía en pedir todos los datos necesarios con un read y guardarlos en una variable ( que ya se hace automáticamente con el read ) y después añadirlos a la base de datos temporal.


## La cuarta función permite eliminar registros.

Se le solicita al usuario introducir una cadena de carácteres y todos aquellos registros los cuales el titulo coincida con algunos de los carácteres introducidos, será eliminado de la base de datos.

Primero se listará las coincidencias encontradas.

Después, antes de eliminar los registros de forma definitiva de la base de datos, se pedirá al usuario una doble confirmación de si quiere eliminar los registros para asegurar que no se borra información importante de la base de datos.

En el caso de que se confirme la operación, se eliminarán los registros listados.

Estas descargas como en la función anterior, no se guardarán una vez se sincronice la base de datos.

### Código

```
remove_register() {

	file_exist	

	#Busca en el la base de datos temporal segun los datos de busqueda que le das.
	printf "Introdueix una serie de caracters per eliminar: \n"
	read research_by_character
	awk -F "," '{if($1 !="title,rating,ratingdescription,ratinglevel,release_year,user_rating_score,user_rating_size") print $0}' $FILE | grep $research_by_character

	#Tiene un bucle while para que te pregunte otra vez sobre la confirmación en caso de que insertes algún char incorrecto.
	is_remove_register_running=false

	while [ "$is_remove_register_running" == "false" ]
	do
		printf "Vols elimiar aquets registres? [Y/N]"
		read remove_register_confirmation_option

		if [ $remove_register_confirmation_option == "Y" ] || [ $remove_register_confirmation_option == "y" ];
		then
			printf "Segur que vols elimiar aquets registres? [Y/N]"
			read remove_register_confirmation_option
			if [ $remove_register_confirmation_option == "Y" ] || [ $remove_register_confirmation_option == "y" ];
			then
				printf "Elimino cosas."
				awk -F "," '{if($1 !="title,rating,ratingdescription,ratinglevel,release_year,user_rating_score,user_rating_size") print $0}' $FILE | grep $research_by_character >> temp_file.csv
				diff -u temp_file.csv $FILE | grep '^\+' | sed -E 's/^\+//' | tail +2 >> temp_file2.csv
				rm $FILE
				cp temp_file2.csv $FILE
				rm temp_file2.csv
				rm temp_file.csv
				is_remove_register_running=true
			elif [ $remove_register_confirmation_option == "N" ] || [ $remove_register_confirmation_option == "n" ];
			then
				printf "No hago nada."
				is_remove_register_running=true
			fi
		elif [ $remove_register_confirmation_option == "N" ] || [ $remove_register_confirmation_option == "n" ];
			then
				printf "No hago nada."
				is_remove_register_running=true
		fi
	done
}
```

### Problemas

Para evitar problemas en esta función, se han reutilizado trozos de código de funciones anteriores que facilitan mucho el trabajo a la hora de buscar entre archivos unos contenidos específicos.
En este caso se ha usado mucho el comando awk para recorrer el archivo y el comando de diff para poder clasificar el contenido de los archivos.


## Fusión de ramas

Con tal de fusionar ramas, debemos estar apuntando a la rama principal aún que primero se tiene que hacer un "git checkout" de todas las ramas para comprobar que están todas actualizadas con el repositorio remoto. Una vez comprobado y estando en la rama principal ( master ) tenemos que introducir el comando "git merge nombre_branch" donde nombre_branch es el nombre de la rama que queremos fusionar a la rama en la que estamos actualmente. Por cada rama cabe la posibilidad de que la fusión automática falle y en ese caso nos pedirá que modifiquemos el archivo con tal de solucionar los errores de compatibilidad. Una vez solucionados los errores con el merge, se hace commit y ya estará la rama fusionada.


## Conclusión

Es una buena práctica para aprender a usar Git ya que se presentan funciones sencillas de realizar y deja mucho más espacio para poder probar y arriesgarte con los comandos de Git. Es una buena forma de poder probar cosas, ya que tienes un repositorio remoto que actua como backup así que puedes probar y manipular todo lo que quieras en tu repositorio local sin preocuparte de estropear el código. En el caso de estropear algo o bien puedes usar los commits locales o simplemente eliminar todo el proyecto de forma local y volverlo a clonar desde el repositorio remoto.
