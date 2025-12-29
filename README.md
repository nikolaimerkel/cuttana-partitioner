# Cuttana 🗡

This repository has the code for the partitioner. 

### Prerequisites and Package Versions

To use this software, make sure you have the following prerequisites installed:

- **make:** Version 4.3 or higher
- **g++ compiler:** Version 11.4 or higher
- **OpenMP:** Version 4.5 (201511) or higher

#### Installation on Ubuntu 22.04 LTS
To install the prerequisites, run the following command:

```bash
sudo apt-get install libomp-dev make g++
```

### Dataset Format

An example dataset is located at `examples/emailEnron.txt`. The file should start with number of vertices and edges following by one line for each vertex that has `vertex_id, degree, space separated list of neighbours`. Basically the file format should be like this:

```
vertex_count edge_count
vertex_id_1 deg_1 nei_1 nei_2 ... 
vertex_id_2 deg_2 nei_1 nei_2 ... 
.
.
.
```

### Building Project and Partitioning

You can easily build project by simply doing:

```
make all
```

The only requirement is OpenMP library and we put the queue inside the project for easier build. 

After building project you can run experiment by:

```
./ogpart -d {dataset} -p {partition_count} -b {imbalance} -vb {vertex_balanced}
```

Where:
1. `dataset` is the relative path to the dataset file. (Specified below)

2. `partition_count` is K in the paper or number of the partitions which is a single integer. 
3. `imbalance` is the 1+epsilon in the paper that controls or relaxes imbalance. Imbalance is a float number. 
4. `vb` is boolean value that controls whether the balance is edge or vertex. 

So for example a valid command is:

```
./ogpart -d data/twitter -p 4 -b 1.05 -vb 1
```

You can also determine number of sub-partitions and buffer size as well. 

### Structure of Project

The code is mostly in `partitioners/ogpart.cpp` where the buffering logic and the control flow is implemented. 

There is two function in the class that you can call. 

The first is ```write_to_file``` which write the output of partitioning in a file in this format for each vertex:

```
vertex_id,partition_id
vertex_id,partition_id
.
.
.
vertex_id,partition_id
```

and a `verify` function which independetly restream the file again and measure the quality metrics. You can also verify and measure quality metrics from the output file of `write_to_file` function. 

The refinement logic is implemented in `partitioners/refine.cpp` and finally a segment tree is implemented in `util` directory. 

### Running Batch Experiment

We facilitate running a group of different experiments on various datasets, partition count, and settings. 

You can read and manipulate `exp.json` which contains the specification and using:

```
./exp.sh exp.json
```

You can run all experiments. 
Also, for an efficient single thread implementation you can use `exp_single_thread.sh`.
### Communication Volume Mode

To optimize for communication volume you should compile with defining `CV` flag. 

This mode has optimizations for communication volume particularly for synchronous graph analytics. 



### Docker

Build
```
docker build -t cuttana .
````

Basic partitioning
```
docker run --rm cuttana ./ogpart -d examples/emailEnron.txt -p 4 -subp 256 -b 1.05 -vb 1
```

With own, for examples. Input directory contains input graph, output directory will contained vid2 pid file 
```sh
docker run --rm \
  -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data \
  -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/output:/app/partitioned_files \
  cuttana ./ogpart -d /data/emailEnron.txt -p 4 -subp 4 -b 1.05 -vb 1
```

```
docker run --rm \
  -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data \
  -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/output:/app/partitioned_files \
  cuttana ./ogpart -d /data/test100.txt.cuttana -p 4 -subp 1 -b 1.05 -vb 1
```




Interactive shell
```
docker run --rm -it cuttana /bin/bash
````

Batch experiments
```
docker run --rm cuttana bash exp.sh exp.json
```

### Create a random edgelist - n
Creates a reandom edgelist for testing purposes
```
docker run --rm -v $(pwd)/input:/data cuttana python3 generate_edgelist.py 1000 5000 -o /data/random_graph_undirec.txt
docker run --rm -v $(pwd)/input:/data cuttana python3 generate_edgelist.py 1000 5000 --directed -o /data/random_directed.txt
docker run --rm -v $(pwd)/input:/data cuttana python3 generate_edgelist.py 1000 5000 --zero-degree -o /data/random_zero.txt
```

### Convert edgelist to cuttana format
The ids will be kept the same. 
```
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./edgelist_to_cuttana /data/test100.txt 
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./edgelist_to_cuttana /data/random_graph_undirec.txt 
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./edgelist_to_cuttana /data/random_directed.txt 
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./edgelist_to_cuttana /data/random_zero.txt 

```

### Issues: 
- vertices with zero degree let the program fail
- the name of input graph matters, it will be checked if `directed` in graph 



-----------------------------

The accepted paper can be found [here](https://www.vldb.org/pvldb/vol18/p14-hajidehi.pdf).

If you used our paper please cite it using this bibtex: 

```
@article{hajidehi2023cuttana,
  title={CUTTANA: Scalable Graph Partitioning for Faster Distributed Graph Databases and Analytics},
  author={Hajidehi, Milad Rezaei and Sridhar, Sraavan and Seltzer, Margo},
  journal={arXiv preprint arXiv:2312.08356},
  year={2023}
}
```
