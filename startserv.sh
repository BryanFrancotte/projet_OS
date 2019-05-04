echo "Démarrage du server, proc $$" 
# path du pipe nomé
pipe=tmp/serverpipe

#cette commande me permet de supprimer le named pipe lorsque le server se coupe.
trap "rm -rf tmp" EXIT
#check pour s'assurer que le pipe n'existe pas avant de le créer.
if [[ ! -d tmp ]]
then
	mkdir tmp
fi
if [[ ! -d tmp/clients ]]
then
	mkdir tmp/clients
fi
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
		IFS=':'
		read -ra parameters <<< "$line"
		clientPID=${parameters[0]}
		clientPipe="tmp/clients/pipe$clientPID"
		command=${parameters[1]}
		cmdResult=$(eval "$command")
		if [[ "${parameters[2]}" == "o" ]]
		then
			outputPath=${parameters[3]}
			if [[ "${parameters[4]}" == "o" ]]
			then
				echo "client PID: $clientPID" >"${outputPath}"
				echo "$cmdResult" >>"${outputPath}"
			else
				echo "client PID: $clientPID" >>"${outputPath}"
				echo "$cmdResult" >>"${outputPath}"
			fi
			
		else
			if [[ "$clientPID" != "${parameters[2]}" ]]
			then
				outputPath=${parameters[2]}
				if [[ "${parameters[3]}" == "o" ]]
				then					
					echo "client PID: $clientPID" >"${outputPath}"
					echo "$cmdResult" >>"${outputPath}"
				else
					echo "client PID: $clientPID" >>"${outputPath}"
					echo "$cmdResult" >>"${outputPath}"
				fi
			fi
			IFS=$'\n'
			cmdResultTab=($cmdResult)
			for i in "${cmdResultTab[@]}"; do
				echo "$i" >"${clientPipe}"
			done
			echo "quit" >"${clientPipe}"
		fi
	fi
done

echo "Arrêt du server! ($$)"

