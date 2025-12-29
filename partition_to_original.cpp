#include <iostream>
#include <fstream>
#include <vector>
#include <algorithm>

using namespace std;

int main(int argc, char* argv[]) {
    if (argc != 4) {
        cerr << "Usage: " << argv[0] << " <new2old_file> <partition_file> <output_file>" << endl;
        cerr << "Converts partition output from renumbered IDs back to original ID order" << endl;
        return 1;
    }

    string new2old_file = argv[1];
    string partition_file = argv[2];
    string output_file = argv[3];

    // Read new2old mapping (line N = old_id for new_id N)
    ifstream mapping_in(new2old_file);
    if (!mapping_in.is_open()) {
        cerr << "Error: Cannot open mapping file " << new2old_file << endl;
        return 1;
    }

    vector<long long> new_to_old;
    new_to_old.push_back(0);  // index 0 unused, new_ids start at 1
    long long old_id;
    while (mapping_in >> old_id) {
        new_to_old.push_back(old_id);
    }
    mapping_in.close();

    long long vertex_count = new_to_old.size() - 1;
    cout << "Loaded mapping for " << vertex_count << " vertices" << endl;

    // Read partition file (line N = partition for new_id N)
    ifstream partition_in(partition_file);
    if (!partition_in.is_open()) {
        cerr << "Error: Cannot open partition file " << partition_file << endl;
        return 1;
    }

    vector<int> partition;
    partition.push_back(0);  // index 0 unused
    int part_id;
    while (partition_in >> part_id) {
        partition.push_back(part_id);
    }
    partition_in.close();

    if (partition.size() - 1 != vertex_count) {
        cerr << "Error: Mapping has " << vertex_count << " vertices but partition has "
             << partition.size() - 1 << endl;
        return 1;
    }

    cout << "Loaded " << vertex_count << " partition assignments" << endl;

    // Create pairs (old_id, partition) and sort by old_id
    vector<pair<long long, int>> old_id_partition;
    for (long long new_id = 1; new_id <= vertex_count; new_id++) {
        old_id_partition.push_back({new_to_old[new_id], partition[new_id]});
    }

    sort(old_id_partition.begin(), old_id_partition.end());

    // Write output: partition for each old_id in sorted order
    ofstream out(output_file);
    if (!out.is_open()) {
        cerr << "Error: Cannot create output file " << output_file << endl;
        return 1;
    }

    for (auto& [oid, part] : old_id_partition) {
        out << part << "\n";
    }
    out.close();

    cout << "Wrote partition output to: " << output_file << endl;
    cout << "Order: sorted by original vertex IDs" << endl;

    return 0;
}
