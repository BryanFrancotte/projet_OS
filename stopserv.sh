while IFS= read -r servpid
do
	echo "$servpid"
	kill $servpid
	rm "servpid.txt"
done < "servpid.txt"
