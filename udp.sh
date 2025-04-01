#!/bin/bash

input_file=udp.csv
output_file=nc_udp_results.csv

echo "IP,Port,Status" > "$output_file"

# Read each line from the input file and process
while IFS=, read -r ip port _
do
    echo "Connecting to UDP $ip:$port..."
    # Run netcat command with timeout
    nc_output=$(nc -u -vvv -z -w3 "$ip" "$port" 2>&1)
    if [[ $? -eq 0 ]]; then
        status="Success/Open/FAIL"
    else
        status="Failure/Closed/PASS"
    fi
    # Print output to stdout
    echo "$nc_output"
    # Write result to output file
    echo "$ip,$port,$status" >> "$output_file"
done < "$input_file"

#to run
#chmod 777 udp.sh
#./udp.sh

#format of udp.csv file (output is from nmaptocsv, edit the csv file in excel: where IP is the up host and OpenPort is openport lol)
# IP,OpenPort
# 10.1.64.1,22
# 10.1.64.1,23
# 10.1.64.1,24
# 10.1.64.1,25
# 10.1.74.1,20
# 10.1.74.1,22
# 10.1.55.1,81
