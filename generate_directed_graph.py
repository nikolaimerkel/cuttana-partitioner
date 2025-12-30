#!/usr/bin/env python3
"""
Generate a random directed graph where:
- Each vertex has at least degree 1 (in or out)
- Vertex IDs are consecutive (1 to N)
"""

import sys
import random
from collections import defaultdict


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <num_vertices> <num_edges> [output_file] [seed]")
        print("  num_vertices: number of vertices (IDs will be 1 to N)")
        print("  num_edges: number of directed edges (must be >= num_vertices)")
        print("  output_file: optional, defaults to 'graph_directed.txt'")
        print("  seed: optional random seed for reproducibility")
        sys.exit(1)

    num_vertices = int(sys.argv[1])
    num_edges = int(sys.argv[2])
    output_file = sys.argv[3] if len(sys.argv) > 3 else "graph_directed.txt"
    seed = int(sys.argv[4]) if len(sys.argv) > 4 else None

    if num_edges < num_vertices:
        print(f"Error: num_edges ({num_edges}) must be >= num_vertices ({num_vertices})")
        print("       to ensure each vertex has at least degree 1")
        sys.exit(1)

    max_edges = num_vertices * (num_vertices - 1)  # directed, no self-loops
    if num_edges > max_edges:
        print(f"Error: num_edges ({num_edges}) exceeds maximum possible ({max_edges})")
        sys.exit(1)

    if seed is not None:
        random.seed(seed)
        print(f"Using random seed: {seed}")

    print(f"Generating directed graph: {num_vertices} vertices, {num_edges} edges")

    edges = set()
    vertex_has_edge = [False] * (num_vertices + 1)  # 1-indexed

    # Phase 1: Ensure each vertex has at least one edge
    print("Phase 1: Ensuring each vertex has at least degree 1...")
    vertices = list(range(1, num_vertices + 1))
    random.shuffle(vertices)

    for v in vertices:
        if vertex_has_edge[v]:
            continue

        # Randomly decide: outgoing or incoming edge
        if random.random() < 0.5:
            # Outgoing edge from v
            candidates = [u for u in range(1, num_vertices + 1) if u != v and (v, u) not in edges]
            if candidates:
                u = random.choice(candidates)
                edges.add((v, u))
                vertex_has_edge[v] = True
                vertex_has_edge[u] = True
        else:
            # Incoming edge to v
            candidates = [u for u in range(1, num_vertices + 1) if u != v and (u, v) not in edges]
            if candidates:
                u = random.choice(candidates)
                edges.add((u, v))
                vertex_has_edge[v] = True
                vertex_has_edge[u] = True

    # Check if any vertex still has no edge (shouldn't happen, but just in case)
    for v in range(1, num_vertices + 1):
        if not vertex_has_edge[v]:
            candidates = [u for u in range(1, num_vertices + 1) if u != v and (v, u) not in edges]
            if candidates:
                u = random.choice(candidates)
                edges.add((v, u))
                vertex_has_edge[v] = True
                vertex_has_edge[u] = True

    print(f"  Created {len(edges)} edges to cover all vertices")

    # Phase 2: Add remaining random edges
    remaining = num_edges - len(edges)
    if remaining > 0:
        print(f"Phase 2: Adding {remaining} random edges...")

        attempts = 0
        max_attempts = remaining * 100

        while len(edges) < num_edges and attempts < max_attempts:
            src = random.randint(1, num_vertices)
            dst = random.randint(1, num_vertices)

            if src != dst and (src, dst) not in edges:
                edges.add((src, dst))

                if len(edges) % 1000000 == 0:
                    print(f"  Added {len(edges) // 1000000}M / {num_edges // 1000000}M edges...")

            attempts += 1

        if len(edges) < num_edges:
            print(f"Warning: Could only create {len(edges)} edges (requested {num_edges})")

    # Write output
    print(f"Writing to: {output_file}")
    with open(output_file, 'w') as f:
        for src, dst in edges:
            f.write(f"{src} {dst}\n")

    # Verify
    in_degree = defaultdict(int)
    out_degree = defaultdict(int)
    for src, dst in edges:
        out_degree[src] += 1
        in_degree[dst] += 1

    min_degree = min(in_degree[v] + out_degree[v] for v in range(1, num_vertices + 1))
    max_out = max(out_degree.values()) if out_degree else 0
    max_in = max(in_degree.values()) if in_degree else 0

    print(f"\nGraph statistics:")
    print(f"  Vertices: {num_vertices}")
    print(f"  Edges: {len(edges)}")
    print(f"  Min total degree: {min_degree}")
    print(f"  Max out-degree: {max_out}")
    print(f"  Max in-degree: {max_in}")
    print(f"  Output: {output_file}")


if __name__ == "__main__":
    main()
