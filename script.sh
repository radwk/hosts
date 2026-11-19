#!/bin/bash

verify-IP() {
	name=$1
	desired_ip=$(grep "$name" "$HOME/etc/hosts" | cut -d' ' -f1)
	if ! nslookup "$name" > /dev/null
	then
		return 2
	fi
	if nslookup "$name" | grep -q "Address: $desired_ip$"
       	then
		echo "$name is valid."
		return 0
	else
		echo "Bogus IP for $name in $HOME/etc/hosts !"
		return 1
	fi
}

while read ip name
do
	if ! echo "$name" | grep -q '\.'
	then
		continue
	fi
	verify-IP "$name"
done < "$HOME/etc/hosts"
