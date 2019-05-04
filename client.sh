#doit on tester si le server est démarrer ? 
pipe=tmp/serverpipe

if [[ ! -p $pipe ]]
then
	echo "Error: le serveur ne tourne pas."
	exit 1
fi

clientPipe="tmp/clients/pipe*$$*"

trap "rm -r ${clientPipe}" EXIT

if [[ ! -p ${clientPipe} ]]
then
	mkfifo ${clientPipe}
fi

echo -n "Introduire une expression pour la commande à exécuter : "
read input

for directory in $(echo $PATH | tr ':' '\n'); do 
#Divide directories in $PATH to one directory each line
	for resultLine in $(find $directory -regextype egrep -regex ".*/$input");
	do
		resultSet=("${resultSet[@]}" "$resultLine") #append the result in the array resultSet
	done
done
if [[ ${#resultSet[@]} == 0 ]]
then
	echo "Error: commande non trouver"
	exit 1
fi
if [[ ${#resultSet[@]} == 1 ]]
then
	choice=${resultSet[0]}
	echo "Commande à executer : $choice"
else
	PS3="Faite votre choix : "
	select choice in ${resultSet[@]}
	do
		if [[ -z $choice ]]
		then
			echo "Error: mauvais choix."
		else
			echo "Commande à executer : $choice"
			break
		fi
	done
fi
echo -n "Introduisez les parametres de la commande : "
read inputParameter
choice="$choice $inputParameter"
echo "Vous souhaitez executer la commande : $choice"
echo -n "Souhaitez-vous que la commande soit ralentie lors de l’exécution ?(o/n) "
read isRunSlow
if [[ "$isRunSlow" == 'o' ]]
then
	choice="nice $choice"
fi
echo -n "Souhaitez-vous que la commande soit lancée en arrière plan ?(o/n) "
read isRunInBackground
if [[ "$isRunInBackground" == 'o' ]]
then
	echo -n "Nom de fichier pour la redirection des résultats : "
	read outputResultFile
	if [[ -e "$outputResultFile" ]]
	then
		echo -n "Fichier $outputResultFile existant, désirez vous l’écraser ?(o/n) "
		read overwriteFileParameter
	fi
	echo "*$$*:$choice:$isRunInBackground:$outputResultFile:$overwriteFileParameter:*$$*" >$pipe
	break
fi
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
	echo "*$$*:$choice:$outputResultFile:$overwriteFileParameter:*$$*" >$pipe
else
	echo "*$$*:$choice:*$$*" >$pipe
fi
while true
do
	if read line
	then
		if [[ "$line" == "quit" ]]
		then
			break
		else
			echo "$line"
		fi
	fi
done <${clientPipe}
#echo "*$$*:$choice:$inputParameter:*$$*" >$pipe

