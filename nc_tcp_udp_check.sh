#!/usr/bin/env bash

set -u

tcp_file="tcp.csv"
udp_file="udp.csv"

run_stamp="$(date '+%Y%m%d_%H%M%S')"
output_file="nc_results_${run_stamp}.csv"
verbose_file="nc_verbose_${run_stamp}.log"

trim() {
    local value="${1//$'\r'/}"
    value="$(printf '%s' "$value" | xargs)"
    printf '%s' "$value"
}

write_result() {
    printf '%s,%s/%s,%s\n' "$1" "$2" "$3" "$4" >> "$output_file"
}

# Log nc output, errors, and exit code; return nc's actual exit code.
run_nc() {
    local exit_code

    {
        printf '\n===== %s | ' "$(date '+%Y-%m-%d %H:%M:%S')"
        printf '%q ' "$@"
        printf '=====\n'

        "$@"
        exit_code=$?

        printf '[nc exit code: %s]\n' "$exit_code"
    } >> "$verbose_file" 2>&1

    return "$exit_code"
}

check_tcp() {
    local ip="$1"
    local port="$2"
    local status

    echo "Testing TCP $ip:$port..."

    if run_nc nc -v -z -w 3 "$ip" "$port"; then
        status="FAIL/Reachable"
    else
        status="PASS/Blocked"
    fi

    write_result "$ip" "$port" "TCP" "$status"
}

check_udp() {
    local ip="$1"
    local port="$2"
    local status

    echo "Testing UDP $ip:$port..."

    if run_nc nc -v -u -z -w 3 "$ip" "$port"; then
        status="INCONCLUSIVE/Probe sent"
    else
        status="INCONCLUSIVE/No response"
    fi

    write_result "$ip" "$port" "UDP" "$status"
}

read_csv() {
    local file="$1"
    local callback="$2"
    local ip port extra

    if [[ ! -f "$file" ]]; then
        printf 'Input file not found: %s\n' "$file" >&2
        return 1
    fi

    while IFS=',' read -r ip port extra || [[ -n "${ip:-}${port:-}${extra:-}" ]]; do
        ip="$(trim "${ip:-}")"
        port="$(trim "${port:-}")"

        [[ -z "$ip" || -z "$port" ]] && continue
        [[ "$ip" == "IP" && "$port" == "Port" ]] && continue

        "$callback" "$ip" "$port"
    done < <(tail -n +2 "$file")
}

printf 'IP,Port/Protocol,Status\n' > "$output_file"
: > "$verbose_file"

read_csv "$tcp_file" check_tcp || true
read_csv "$udp_file" check_udp || true

echo
echo "Testing complete."
echo "Results: $output_file"
echo "Verbose nc log: $verbose_file"