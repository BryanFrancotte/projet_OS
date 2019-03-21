echo -n "Introduire une expression pour la commande à exécuter : "
read inputRegEx
echo $inputRegEx

for directory in $(echo $PATH | tr ':' '\n'); do 
#Divide directories in $PATH to one directory each line
	find $directory -name "$inputRegEx"
done
