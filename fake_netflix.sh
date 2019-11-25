#!/bin/sh

#Nombre del archivo csv que queremos usar.
file_name=netflix.csv

#Nombre del archivo csv ya filtrado que va a sustituir al original.
output_file=output_file.csv

#Enseña las opciones.
print_main_menu() {

	printf "\n		FakeNetflix\n
1) Recomanació ràpida.\n
2) Llistar per any.\n
3) Llistar per rating.\n
4) Criteris de cerca.\n
5) Sortir\n\nOpció: "

}

#Genera un número aleatorio, selecciona y enseña los datos de la película de esa linea.
fast_recomendation() {

	printf " 	--------------------------------------------------  \n
			Recomanació ràpida\n
	--------------------------------------------------\n\n"

	#Cuenta el número de lineas del archivo.
	number_of_lines="$(< $file_name wc -l)"

	#Genera un número aleatorio entre 1 y el máximo de lineas de un archivo.
	random_number="$(shuf -i 1-$number_of_lines -n 1)"

	#Busca la linea random y hace print de las variables que le indicamos.
	awk -F ',' '{if(NR=='$random_number') print "Nom: " $1 ", " "Any: " $5 "\n" "Rating: " $2 "\n" "Descripció: " $3 "\n"}' $file_name

}

#Busca por año el contenido multimedia y muestra su nombre y su rating.
year_list() {

	#Año pedido por consola.
	printf "Introdueix l'any per el que vols filtar: \n"
	read year

	#Si el año introducido coincide con el año del contenido multimedia muestra su nombre y rating.
	awk -F ',' '{if($5=='$year') print "\n"  "Nom: " $1 ", " "Any: " $5}' $file_name

}

rating_list() {
	
	#Rating pedido por consola.
	printf "Introdueix el rating de 1 a 5 per el que vols filtrar: \n"
	read rating
	
	#
	case $rating in
            '1') awk -F ',' '{if($6<65&&$6>=0) print "Valoració: " "*  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6<75&&$6>=65) print "**  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6<85&&$6>=75) print "***  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6<95&&$6>=85) print "****  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6>=95) print "*****  " $1 ", " $2}' $file_name;;
            '2') awk -F ',' '{if($6<75&&$6>=65) print "**  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6<85&&$6>=75) print "***  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6<95&&$6>=85) print "****  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6>=95) print "*****  " $1 ", " $2}' $file_name;;
	    '3') awk -F ',' '{if($6<85&&$6>=75) print "***  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6<95&&$6>=85) print "****  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6>=95) print "*****  " $1 ", " $2}' $file_name;;
            '4') awk -F ',' '{if($6<95&&$6>=85) print "****  " $1 ", " $2}' $file_name;
		 awk -F ',' '{if($6>=95) print "*****  " $1 ", " $2}' $file_name;;
	    '5') awk -F ',' '{if($6>=95) print "*****  " $1 ", " $2}' $file_name;;
            *)   printf "Error, $rating no es una opció vàlida, tornant al menu..."; sleep 3; clear;;
        esac 
}

#Elimina las lineas que están repetidas.
delete_dupiclate_lines() {

	sort $file_name | uniq > $output_file
	rm netflix.csv
	mv $output_file $file_name

}

#Actualiza el archivo local netflix.csv añadiendo el contenido de un archivo almacenado en GitHub
synchronize_catalogue() {

	wget https://raw.githubusercontent.com/acocauab/practica2csv/master/test.csv
	diff -u netflix.csv test.csv | grep '^\+' | sed -E 's/^\+//' | tail +2 >> netflix.csv
	rm test.csv	

}

#Principio de las funciones del menú criterios de búsqueda.--------------------------------------------------------

print_search_criteria_menu(){

	printf "\n		FakeNetflix\n
		Criteris de cerca\n
a) Modificar preferències.\n
b) Eliminar preferències.\n
c) Preferències actuals.\n
d) Sortir\n\nOpció: "

}

#Funcion para poder modificar las preferencias.
modify_preferences(){

awk -F ',' '{print $5}' $file_name > years.csv

sort years.csv | uniq > years_final.csv
rm years.csv
mv years_final.csv years.csv

awk -F ',' '{if($1 != "release_year") print "Anys que pots seleccionar:\n" $1}' years.csv

awk -F ',' '{print $5}' $file_name > years.csv

sort years.csv | uniq > years_final.csv
rm years.csv
mv years_final.csv years.csv
}

delete_preferences(){
	printf "Estoy en construcción"
}

actual_preferences(){
	printf "Estoy en construcción"
}

#Funcion que añade un menu dónde puedes modificar las preferencias de las recomendaciones rápidas.
search_criteria(){

search_criteria_menu_option=""

while [ "$search_criteria_menu_option" != "d" ]
do
	print_search_criteria_menu

        read search_criteria_menu_option

	clear

        case $search_criteria_menu_option in
            'a') modify_preferences;;
            'b') delete_preferences;;
	    'c') actual_preferences;;
            'd') printf "Sortir...";;
            *)   printf "Error, $search_criteria_menu_option no es una opció vàlida, tornant al menu..."; sleep 3; clear;;
        esac
done

}

#Fin de las funciones del menú criterios de búsqueda.------------------------------------------------------------

delete_dupiclate_lines

main_menu_option=""

while [ "$main_menu_option" != "5" ]
do
	print_main_menu

        read main_menu_option

	clear

        case $main_menu_option in
            '1') fast_recomendation;;
            '2') year_list;;
	    '3') rating_list;;
	    '4') search_criteria;;
            '5') printf "Sortir...";;
            *)   printf "Error, $main_menu_option no es una opció vàlida, tornant al menu..."; sleep 3; clear;;
        esac
done
