#!/bin/bash

hosts_file="$1"
if [ ! -f "$hosts_file" ]; then
  echo "Error: File '$hosts_file' does not exist."
  exit 1
fi

verify-IP() {
  name=$1
  desired_ip=$(grep "$name" "$hosts_file" | cut -d' ' -f1)
  if ! nslookup "$name" >/dev/null; then
    return 2
  fi
  if nslookup "$name" | grep -q "Address: $desired_ip$"; then
    echo "$name is valid."
    return 0
  else
    echo "Bogus IP for $name in $hosts_file !"
    return 1
  fi
}

while read ip name; do
  if ! echo "$name" | grep -q '\.'; then
    continue
  fi
  verify-IP "$name"
done <"$hosts_file"

echo "Modified by David Matei"
