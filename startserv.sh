echo "Démarrage du server, proc $$" 
# path du pipe nomé
pipe=/tmp/serverpipe

#cette commande me permet de supprimer le named pipe lorsque le server se coupe.
trap "rm -f $pipe" EXIT
#check pour s'assurer que le pipe n'existe pas avant de le créer.
#if [[ ! -d /tmp ]]
#then
#	mkdir /tmp
#fi
if [[ ! -p $pipe ]]
then
	mkfifo $pipe
fi
#lecture du pipe nomé.
while true
do
	if read line <$pipe
	then	
		#si dans le pipe apparait un 'quit' alors le server s'arrête.
		if [[ "$line" == 'quit' ]] #=> il faut checker si le quit n'est pas une commande.
		then
			break
		fi
		echo $line

		IFS=':'
		read -ra parameters <<< "$line"
		clientPID=${parameters[0]}
		command=${parameters[1]}
		commandParameter=${parameters[2]}
		if [[ "$clientPID" != "${parameters[3]}" ]]
		then
			outputPath=${parameters[3]}
		fi
		echo "client PID: $clientPID" >"${outputPath}"
		$command >"${outputPath}"
	fi
done

echo "Arrêt du server! ($$)"

