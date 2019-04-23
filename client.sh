#doit on tester si le server est démarrer ? 

pipe=/tmp/serverpipe

echo -n "Introduire une expression pour la commande à exécuter : "
read input

for directory in $(echo $PATH | tr ':' '\n'); do 
#Divide directories in $PATH to one directory each line
	for resultLine in $(find $directory -regextype egrep -regex ".*/$input");
	do
		resultSet=("${resultSet[@]}" "$resultLine") #append the result in the array resultSet
	done
done

PS3="Faite votre choix : "
select choice in ${resultSet[@]}
do
	if [[ -z $choice ]]
	then
		break
	else
		echo "Commande à executer : $choice"
		echo -n "Introduisez les parametres de la commande : "
		read inputParameter
		echo "Vous souhaitez executer la commande : $choice $inputParameter"
		echo -n "Souhaitez-vous que la commande soit ralentie lors de l’exécution ?(o/n) "
		read isRunSlow
		echo -n "Souhaitez-vous que la commande soit lancée en arrière plan ?(o/n) "
		read isRunInBackground
		echo -n "Souhaitez-vous que la sortie standard soit redirigée ?(o/n) "
		read isOutputRedirected
		if [[ "$isOutputRedirected" == 'o' ]]
		then
			echo -n "Nom de fichier pour la redirection des résultats : "
			read outputResultFile
			if [[ -e "$outputResultFile" ]]
			then
				echo -n "Fichier $outputResultFile existant, désirez vous l’écraser ?(o/n) "
				read overwriteFileParameter
			fi
			echo "*$$*:$choice:$inputParameter:$outputResultFile:*$$*" >$pipe
		fi
		break
	fi
done
#echo "*$$*:$choice:$inputParameter:*$$*" >$pipe

