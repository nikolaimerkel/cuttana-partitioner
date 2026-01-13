#!/usr/bin/env python3

import sys

# List of graph files (without path prefix)
GRAPHS = [
    "ogbn-papers100M",
    "ogbn-arxiv",
    "ogbn-products",
    "reddit",
]

# List of partition counts to run
PARTITION_COUNTS = [2,4,8,16,32]

# Fixed parameters
SUBP = 256
BALANCE = 1.05
VERTEX_BALANCE = 1


def cmd_convert(graph: str, data_path: str) -> str:
    return f"docker run --rm -v {data_path}:/data cuttana ./directed_edgelist_to_directed_cuttana /data/{graph}"


def cmd_partition(graph: str, partitions: int, data_path: str) -> str:
    return (
        f"docker run --rm -v {data_path}:/data cuttana "
        f"./ogpart -d /data/{graph}.directed.cuttana -p {partitions} -subp {SUBP} -b {BALANCE} -vb {VERTEX_BALANCE} -directed"
    )


def cmd_to_original(graph: str, partitions: int, data_path: str) -> str:
    base = f"/data/{graph}.directed.cuttana"
    new2old = f"{base}.new2old"
    partition_in = f"{base}.cuttana{SUBP}.P{partitions}.tmp"
    partition_out = f"{base}.cuttana{SUBP}.P{partitions}.vid2pid"
    return (
        f"docker run --rm -v {data_path}:/data cuttana "
        f"./partition_to_original {new2old} {partition_in} {partition_out}"
    )


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <data_path>")
        print("  data_path: absolute path to directory containing edgelist files")
        sys.exit(1)

    data_path = sys.argv[1]
    commands = []

    for graph in GRAPHS:
        # Convert once per graph

        commands.append(cmd_convert(graph, data_path))

        # Partition and convert back for each partition count
        for p in PARTITION_COUNTS:
            commands.append(cmd_partition(graph, p, data_path))
            commands.append(cmd_to_original(graph, p, data_path))

    # Write to run_directed.sh
    with open("run_directed.sh", "w") as f:
        f.write("#!/bin/bash\nset -e\n\n")
        for cmd in commands:
            f.write(cmd + "\n")

    print(f"Generated run_directed.sh with {len(commands)} commands")


if __name__ == "__main__":
    main()
