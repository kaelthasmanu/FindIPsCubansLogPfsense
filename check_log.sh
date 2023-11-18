#!/bin/bash

log_file="/var/log/pfsense/default.log"
cidr_file="archivo_de_cidr.txt"
output_file="coincidencias.txt"

function cidr_to_ip_list {
  local cidr="$1"
  local ip_list=()

  while read -r line; do
    ip_list+=("$line")
  done < <(ipcalc -n -b -s -m "$cidr" | grep "Address:" | cut -d' ' -f 2)

  echo "List IPs : ${ip_list[@]}"
}

while IFS= read -r cidr; do
  ip_list=($(cidr_to_ip_list "$cidr"))
  for ip in "${ip_list[@]}"; do
    grep -F "$ip" "$log_file" >> "$output_file"
  done
done < "$cidr_file"

echo "Búsqueda completada. Las coincidencias se han guardado en $output_file"
