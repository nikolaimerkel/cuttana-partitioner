#!/usr/bin/env python3
"""
Convert edgelist to CUTTANA directed graph format.

Input: edgelist file with "src dst" per line
Output:
  - {input}.directed.cuttana - graph in CUTTANA format
  - {input}.directed.cuttana.new2old - vertex ID mapping
"""

import sys
from collections import defaultdict


def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <edgelist_file>")
        print("Converts edgelist to CUTTANA directed graph format")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = input_file + ".directed.cuttana"
    mapping_file = output_file + ".new2old"

    print(f"Reading edgelist from: {input_file}")

    # Build directed adjacency list
    adjacency_list = defaultdict(set)
    edge_count = 0
    edges_read = 0

    with open(input_file, 'r') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            parts = line.split()
            if len(parts) < 2:
                continue

            src, dst = int(parts[0]), int(parts[1])

            # Directed: only add edge in one direction
            if dst not in adjacency_list[src]:
                adjacency_list[src].add(dst)
                edge_count += 1

            # Ensure dst vertex exists in adjacency list (may have no outgoing edges)
            if dst not in adjacency_list:
                adjacency_list[dst] = set()

            edges_read += 1
            if edges_read % 1000000 == 0:
                print(f"  Read {edges_read // 1000000}M edges...")

    print(f"  Finished reading: {edge_count} unique directed edges, {len(adjacency_list)} vertices")

    # Collect and sort vertex IDs
    print("Sorting vertex IDs...")
    sorted_old_ids = sorted(adjacency_list.keys())
    vertex_count = len(sorted_old_ids)

    # Build old_to_new mapping (new IDs start at 1)
    print("Building ID mapping...")
    old_to_new = {old_id: new_id + 1 for new_id, old_id in enumerate(sorted_old_ids)}

    # Write new2old mapping
    print(f"Writing mapping to: {mapping_file}")
    with open(mapping_file, 'w') as f:
        for old_id in sorted_old_ids:
            f.write(f"{old_id}\n")

    # Build renumbered adjacency list
    print("Renumbering adjacency list...")
    renumbered_adj = defaultdict(list)
    progress = 0
    for old_id, neighbors in adjacency_list.items():
        new_src = old_to_new[old_id]
        renumbered_adj[new_src] = [old_to_new[n] for n in neighbors]
        progress += 1
        if progress % 1000000 == 0:
            print(f"  Renumbered {progress // 1000000}M / {vertex_count // 1000000}M vertices...")

    # Handle vertices with no outgoing edges (add self-loop)
    zero_out_degree = 0
    for vid in range(1, vertex_count + 1):
        if len(renumbered_adj[vid]) == 0:
            renumbered_adj[vid] = [vid]
            zero_out_degree += 1

    print(f"Vertices: {vertex_count}")
    print(f"Directed edges: {edge_count}")
    if zero_out_degree > 0:
        print(f"Added self-loops for {zero_out_degree} zero-out-degree vertices")

    # Write output in CUTTANA format
    print(f"Writing output to: {output_file}")
    with open(output_file, 'w') as f:
        # Header: vertex_count edge_count
        f.write(f"{vertex_count} {edge_count}\n")

        # Adjacency list for each vertex
        for vid in range(1, vertex_count + 1):
            neighbors = renumbered_adj[vid]
            f.write(f"{vid} {len(neighbors)}")
            for neighbor in neighbors:
                f.write(f" {neighbor}")
            f.write("\n")

            if vid % 1000000 == 0:
                print(f"  Written {vid // 1000000}M / {vertex_count // 1000000}M vertices...")

    print("Conversion complete!")
    print(f"Output: {output_file}")
    print(f"Mapping: {mapping_file}")
    print("\nNote: Filename contains 'directed' so ogpart will treat it as a directed graph.")


if __name__ == "__main__":
    main()
