#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <map>
#include <set>
#include <vector>

using namespace std;

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <edgelist_file>" << endl;
        cerr << "Converts edgelist to CUTTANA undirected graph format" << endl;
        return 1;
    }

    string input_file = argv[1];
    string output_file = input_file + ".cuttana";

    // Map to store adjacency list: vertex_id -> set of neighbors
    map<long long, set<long long>> adjacency_list;
    long long edge_count = 0;

    // Read the edgelist file
    ifstream infile(input_file);
    if (!infile.is_open()) {
        cerr << "Error: Cannot open file " << input_file << endl;
        return 1;
    }

    cout << "Reading edgelist from: " << input_file << endl;

    string line;
    while (getline(infile, line)) {
        if (line.empty()) continue;

        stringstream ss(line);
        long long src, dst;

        if (!(ss >> src >> dst)) {
            continue;
        }

        // Add both directions (undirected graph)
        adjacency_list[src].insert(dst);
        adjacency_list[dst].insert(src);
        edge_count++;
    }
    infile.close();

    // Renumber vertices to be sequential (1, 2, 3, ... N)
    map<long long, long long> old_to_new;
    long long new_id = 1;
    for (auto& [old_id, neighbors] : adjacency_list) {
        old_to_new[old_id] = new_id++;
    }

    // Create renumbered adjacency list
    map<long long, set<long long>> renumbered_adj;
    for (auto& [old_id, neighbors] : adjacency_list) {
        long long new_src = old_to_new[old_id];
        for (long long old_neighbor : neighbors) {
            renumbered_adj[new_src].insert(old_to_new[old_neighbor]);
        }
    }
    adjacency_list = renumbered_adj;

    long long vertex_count = adjacency_list.size();

    // Add self-loops for vertices with degree 0
    long long zero_degree_count = 0;
    for (auto& [vertex_id, neighbors] : adjacency_list) {
        if (neighbors.empty()) {
            neighbors.insert(vertex_id);
            zero_degree_count++;
        }
    }

    // Count total edges (each edge appears twice in undirected graph)
    long long total_edges = 0;
    for (auto& [vertex_id, neighbors] : adjacency_list) {
        total_edges += neighbors.size();
    }

    total_edges = total_edges / 2;

    cout << "Vertices: " << vertex_count << endl;
    cout << "Input edges: " << edge_count << endl;
    cout << "Total adjacency entries: " << total_edges << " (undirected)" << endl;
    if (zero_degree_count > 0) {
        cout << "Added self-loops for " << zero_degree_count << " zero-degree vertices" << endl;
    }

    // Write to output file in CUTTANA format
    ofstream outfile(output_file);
    if (!outfile.is_open()) {
        cerr << "Error: Cannot create output file " << output_file << endl;
        return 1;
    }

    // Write header: vertex_count edge_count
    outfile << vertex_count << " " << total_edges << "\n";

    // Write adjacency list for each vertex
    for (auto& [vertex_id, neighbors] : adjacency_list) {
        outfile << vertex_id << " " << neighbors.size();
        for (long long neighbor : neighbors) {
            outfile << " " << neighbor;
        }
        outfile << "\n";
    }

    outfile.close();

    cout << "Conversion complete!" << endl;
    cout << "Output: " << output_file << endl;

    return 0;
}
