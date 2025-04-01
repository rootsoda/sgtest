#!/bin/bash

input_file=tcp.csv
output_file=nc_tcp_results.csv

echo "IP,Port,Status" > "$output_file"

# Read each line from the input file and process
while IFS=, read -r ip port _
do
    echo "Connecting to $ip:$port..."
    # Run netcat command with timeout
    nc_output=$(nc -vvv -z -w3 "$ip" "$port" 2>&1)
    if [[ $? -eq 0 ]]; then
        status="Open/Fail"
    else
        status="Pass/Refused"
    fi
    # Print output to stdout
    echo "$nc_output"
    # Write result to output file
    echo "$ip,$port,$status" >> "$output_file"
done < "$input_file"

#to run
#chmod 777 tcp.sh
#./tcp.sh

#format of tcp.csv file (output is from nmaptocsv, edit the csv file in excel: where IP is the up host and OpenPort is openport lol)
# IP,OpenPort
# 10.1.64.1,22
# 10.1.64.1,23
# 10.1.64.1,24
# 10.1.64.1,25
# 10.1.74.1,20
# 10.1.74.1,22
# 10.1.55.1,81
