#while IFS= read -r servpid
#do
#	echo "$servpid"
#	kill $servpid
#	rm "servpid.txt"
#done < "servpid.txt"

pipe=/tmp/serverpipe
#check si le pipe nomé existe, aka le server est en fonction.
if [[ ! -p $pipe ]]
then
	echo "Error: Le server ne tourne pas."
	exit 1
fi

echo "quit" >$pipe
#rmdir /tmp
#doit on effacer d'autre fichiers residuel ??

