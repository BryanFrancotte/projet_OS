declare -a fruits=("element1" "element2" "element3")
for test in ${fruits[@]}
do
echo $test
done

PS3="Votre choix?"
select fruit in ${fruits[@]}
do
	if [[ -z "$fruit" ]]
	then
		break
	else
		echo "le fruit choisi : $fruit"
	fi
done

