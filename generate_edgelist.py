#!/usr/bin/env python3
"""
Generate random graph edgelist for testing.

Usage:
    python3 generate_edgelist.py <vertices> <edges> [--directed] [--zero-degree] [-o output.txt]

Examples:
    python3 generate_edgelist.py 100 500                        # Undirected, 100 vertices, 500 edges
    python3 generate_edgelist.py 100 500 --directed             # Directed graph
    python3 generate_edgelist.py 100 500 --zero-degree          # Include vertex with degree 0
    python3 generate_edgelist.py 100 500 --directed --zero-degree -o graph.txt
"""

import argparse
import random
import sys

def generate_edgelist(num_vertices, num_edges, directed=False, zero_degree=False, output_file=None):
    """Generate a random graph edgelist."""

    if num_vertices < 1:
        print("Error: Number of vertices must be at least 1", file=sys.stderr)
        sys.exit(1)

    # If no output file specified, create default name
    # Important: avoid "directed" substring in undirected filenames (CUTTANA detection issue)
    if output_file is None:
        graph_type = "directed" if directed else "undirec"  # Note: "undirec" not "undirected"
        output_file = f"random_graph_{graph_type}_{num_vertices}v_{num_edges}e.txt"

    # Calculate maximum possible edges
    if directed:
        max_edges = num_vertices * (num_vertices - 1)  # No self-loops
    else:
        max_edges = num_vertices * (num_vertices - 1) // 2  # Undirected, no self-loops

    if num_edges > max_edges:
        print(f"Error: Too many edges. Maximum for {num_vertices} vertices is {max_edges} ({'directed' if directed else 'undirected'})", file=sys.stderr)
        sys.exit(1)

    # Generate edges
    edges = set()
    vertices_with_edges = set()

    # If zero_degree is requested, reserve one vertex (vertex 1) to have no edges
    reserved_vertex = 1 if zero_degree else None
    available_vertices = list(range(1, num_vertices + 1))
    if reserved_vertex:
        available_vertices.remove(reserved_vertex)

    # Generate random edges
    attempts = 0
    max_attempts = num_edges * 100  # Prevent infinite loop

    while len(edges) < num_edges and attempts < max_attempts:
        attempts += 1

        # Pick two random vertices
        src = random.choice(available_vertices)
        dst = random.choice(available_vertices)

        # Skip if same vertex (no self-loops)
        if src == dst:
            continue

        # For undirected graphs, normalize edge order
        if not directed and src > dst:
            src, dst = dst, src

        # Add edge
        edge = (src, dst)
        if edge not in edges:
            edges.add(edge)
            vertices_with_edges.add(src)
            vertices_with_edges.add(dst)

    if len(edges) < num_edges:
        print(f"Warning: Could only generate {len(edges)} unique edges (requested {num_edges})", file=sys.stderr)

    # Sort edges for consistent output
    edges = sorted(edges)

    # For undirected graphs, create both directions
    if not directed:
        bidirectional_edges = []
        for src, dst in edges:
            bidirectional_edges.append((src, dst))
            bidirectional_edges.append((dst, src))
        edges = sorted(bidirectional_edges)

    # Write to file or stdout
    if output_file:
        with open(output_file, 'w') as f:
            for src, dst in edges:
                f.write(f"{src} {dst}\n")
        actual_edges = len(edges) // 2 if not directed else len(edges)
        graph_type_display = "directed" if directed else "undirected (bidirectional)"
        print(f"Generated {graph_type_display} graph:", file=sys.stderr)
        print(f"  Vertices: {num_vertices}", file=sys.stderr)
        print(f"  Unique edges: {actual_edges}", file=sys.stderr)
        print(f"  Edgelist entries: {len(edges)}", file=sys.stderr)
        if zero_degree:
            print(f"  Zero-degree vertex: {reserved_vertex}", file=sys.stderr)
        print(f"  Output: {output_file}", file=sys.stderr)
    else:
        for src, dst in edges:
            print(f"{src} {dst}")
        actual_edges = len(edges) // 2 if not directed else len(edges)
        graph_type_display = "directed" if directed else "undirected (bidirectional)"
        print(f"# Generated {graph_type_display} graph: {num_vertices} vertices, {actual_edges} unique edges", file=sys.stderr)
        if zero_degree:
            print(f"# Zero-degree vertex: {reserved_vertex}", file=sys.stderr)

def main():
    parser = argparse.ArgumentParser(
        description='Generate random graph edgelist',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  %(prog)s 100 500                        # Undirected, 100 vertices, 500 edges
  %(prog)s 100 500 --directed             # Directed graph
  %(prog)s 100 500 --zero-degree          # Include vertex with degree 0
  %(prog)s 100 500 --directed --zero-degree -o graph.txt
        """
    )

    parser.add_argument('vertices', type=int, help='Number of vertices')
    parser.add_argument('edges', type=int, help='Number of edges')
    parser.add_argument('--directed', action='store_true',
                        help='Generate directed graph (default: undirected/bidirectional)')
    parser.add_argument('--zero-degree', action='store_true',
                        help='Include at least one vertex with degree 0')
    parser.add_argument('-o', '--output', type=str, default=None,
                        help='Output file (default: auto-generated name avoiding "directed" substring for undirected graphs)')

    args = parser.parse_args()

    generate_edgelist(
        num_vertices=args.vertices,
        num_edges=args.edges,
        directed=args.directed,
        zero_degree=args.zero_degree,
        output_file=args.output
    )

if __name__ == '__main__':
    main()
