### Prerequisites

- **Bash:** Run the script in a Bash shell. On Windows, use an environment such as WSL or Git Bash.
- **Netcat (`nc`):** Install a version that supports `-v`, `-z`, `-w`, and UDP mode with `-u`. Options can vary across operating systems.
- **Input files:** Place `tcp.csv` and `udp.csv` in the same directory where you run the script. Each needs an `IP,Port` header, followed by one target per line.
- **Authorized targets:** Use only IP addresses and ports you’re authorized to test, and run the script from the network location relevant to the segmentation check.
- **Write access:** The script’s directory must allow it to create the timestamped results CSV and verbose log files.
- **Execution permission:** Save the script as a `.sh` file and make it executable with `chmod +x scriptname.sh`, or run it with `bash scriptname.sh`.
- **Network access:** The machine must have a route to the target networks. Firewalls, routing, and host availability can affect results.
- **UDP interpretation:** UDP `nc` results are inconclusive when there’s no response. Use a protocol-aware probe, such as a DNS query for port 53, when you need to verify UDP reachability.
