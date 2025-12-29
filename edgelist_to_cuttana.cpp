#include <iostream>
#include <fstream>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>
#include <algorithm>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>

using namespace std;

// Fast integer parsing from memory-mapped buffer
template <typename T>
inline T read_int(char*& ptr, char* end) {
    // Skip non-digit characters (whitespace, newlines)
    while (ptr < end && !isdigit(*ptr) && *ptr != '-') ptr++;
    if (ptr >= end) return -1;

    bool negative = false;
    if (*ptr == '-') {
        negative = true;
        ptr++;
    }

    T num = 0;
    while (ptr < end && isdigit(*ptr)) {
        num = num * 10 + (*ptr - '0');
        ptr++;
    }
    return negative ? -num : num;
}

// Skip to next line
inline void skip_line(char*& ptr, char* end) {
    while (ptr < end && *ptr != '\n') ptr++;
    if (ptr < end) ptr++;  // skip the newline
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        cerr << "Usage: " << argv[0] << " <edgelist_file>" << endl;
        cerr << "Converts edgelist to CUTTANA undirected graph format" << endl;
        return 1;
    }

    string input_file = argv[1];
    string output_file = input_file + ".cuttana";

    // Map to store adjacency list: vertex_id -> set of neighbors
    unordered_map<long long, unordered_set<long long>> adjacency_list;
    long long edge_count = 0;

    // Memory-map the input file for fast reading
    cout << "Reading edgelist from: " << input_file << endl;

    int fd = open(input_file.c_str(), O_RDONLY);
    if (fd == -1) {
        cerr << "Error: Cannot open file " << input_file << endl;
        return 1;
    }

    // Get file size
    struct stat sb;
    if (fstat(fd, &sb) == -1) {
        cerr << "Error: Cannot get file size" << endl;
        close(fd);
        return 1;
    }
    size_t file_size = sb.st_size;
    cout << "  File size: " << file_size / (1024 * 1024) << " MB" << endl;

    // Memory-map the file
    char* data = (char*)mmap(nullptr, file_size, PROT_READ, MAP_PRIVATE, fd, 0);
    if (data == MAP_FAILED) {
        cerr << "Error: Cannot memory-map file" << endl;
        close(fd);
        return 1;
    }

    char* ptr = data;
    char* end = data + file_size;

    long long edges_read = 0;
    while (ptr < end) {
        long long src = read_int<long long>(ptr, end);
        if (ptr >= end) break;
        long long dst = read_int<long long>(ptr, end);
        if (src < 0 || dst < 0) break;  // end of valid data

        // Add both directions (undirected graph)
        adjacency_list[src].insert(dst);
        adjacency_list[dst].insert(src);
        edge_count++;
        edges_read++;

        if (edges_read % 1000000 == 0) {
            cout << "  Read " << edges_read / 1000000 << "M edges, "
                 << adjacency_list.size() << " vertices so far..." << endl;
        }
    }

    // Cleanup mmap
    munmap(data, file_size);
    close(fd);

    cout << "  Finished reading: " << edge_count << " edges, "
         << adjacency_list.size() << " vertices" << endl;

    // Collect and sort old vertex IDs
    cout << "Collecting vertex IDs..." << endl;
    vector<long long> sorted_old_ids;
    sorted_old_ids.reserve(adjacency_list.size());
    long long collect_progress = 0;
    for (auto& [old_id, neighbors] : adjacency_list) {
        sorted_old_ids.push_back(old_id);
        collect_progress++;
        if (collect_progress % 1000000 == 0) {
            cout << "  Collected " << collect_progress / 1000000 << "M / "
                 << adjacency_list.size() / 1000000 << "M IDs..." << endl;
        }
    }
    cout << "Sorting " << sorted_old_ids.size() << " vertex IDs..." << endl;
    sort(sorted_old_ids.begin(), sorted_old_ids.end());
    cout << "  Sorting complete." << endl;

    // Build old_to_new mapping (O(1) lookup with unordered_map)
    cout << "Building ID mapping..." << endl;
    unordered_map<long long, long long> old_to_new;
    old_to_new.reserve(sorted_old_ids.size());
    for (long long i = 0; i < (long long)sorted_old_ids.size(); i++) {
        old_to_new[sorted_old_ids[i]] = i + 1;  // new IDs start at 1
        if ((i + 1) % 1000000 == 0) {
            cout << "  Mapped " << (i + 1) / 1000000 << "M / "
                 << sorted_old_ids.size() / 1000000 << "M IDs..." << endl;
        }
    }
    cout << "  Mapping complete." << endl;

    long long vertex_count = sorted_old_ids.size();

    // Create renumbered adjacency list using vector (O(1) access)
    cout << "Renumbering adjacency list..." << endl;
    vector<vector<long long>> renumbered_adj(vertex_count + 1);
    long long renumber_progress = 0;
    for (auto& [old_id, neighbors] : adjacency_list) {
        renumber_progress++;
        if (renumber_progress % 1000000 == 0) {
            cout << "  Renumbered " << renumber_progress / 1000000 << "M / "
                 << vertex_count / 1000000 << "M vertices..." << endl;
        }
        long long new_src = old_to_new[old_id];
        renumbered_adj[new_src].reserve(neighbors.size());
        for (long long old_neighbor : neighbors) {
            renumbered_adj[new_src].push_back(old_to_new[old_neighbor]);
        }
    }

    // Free original adjacency list memory
    adjacency_list.clear();

    // Write new2old mapping (line N = old_id for new_id N)
    cout << "Writing mapping file..." << endl;
    string mapping_file = output_file + ".new2old";
    ofstream mapping_out(mapping_file);
    if (!mapping_out.is_open()) {
        cerr << "Error: Cannot create mapping file " << mapping_file << endl;
        return 1;
    }
    for (long long old_id : sorted_old_ids) {
        mapping_out << old_id << "\n";
    }
    mapping_out.close();
    cout << "Wrote mapping to: " << mapping_file << endl;

    // Add self-loops for vertices with degree 0
    long long zero_degree_count = 0;
    for (long long vid = 1; vid <= vertex_count; vid++) {
        if (renumbered_adj[vid].empty()) {
            renumbered_adj[vid].push_back(vid);
            zero_degree_count++;
        }
    }

    // Count total edges (each edge appears twice in undirected graph)
    long long total_edges = 0;
    for (long long vid = 1; vid <= vertex_count; vid++) {
        total_edges += renumbered_adj[vid].size();
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
    cout << "Writing output file..." << endl;
    for (long long vid = 1; vid <= vertex_count; vid++) {
        if (vid % 1000000 == 0) {
            cout << "  Written " << vid / 1000000 << "M / "
                 << vertex_count / 1000000 << "M vertices..." << endl;
        }
        outfile << vid << " " << renumbered_adj[vid].size();
        for (long long neighbor : renumbered_adj[vid]) {
            outfile << " " << neighbor;
        }
        outfile << "\n";
    }

    outfile.close();
    cout << "  Write complete." << endl;

    cout << "Conversion complete!" << endl;
    cout << "Output: " << output_file << endl;

    return 0;
}
