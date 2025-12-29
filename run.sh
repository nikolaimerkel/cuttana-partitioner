#!/bin/bash
set -e

docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./edgelist_to_cuttana /data/random_graph_undirec.txt
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/random_graph_undirec.txt.cuttana -p 4 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/random_graph_undirec.txt.cuttana.new2old /data/random_graph_undirec.txt.cuttana.cuttana256.P4.tmp /data/random_graph_undirec.txt.cuttana.cuttana256.P4
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/random_graph_undirec.txt.cuttana -p 8 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/random_graph_undirec.txt.cuttana.new2old /data/random_graph_undirec.txt.cuttana.cuttana256.P8.tmp /data/random_graph_undirec.txt.cuttana.cuttana256.P8
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/random_graph_undirec.txt.cuttana -p 16 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/random_graph_undirec.txt.cuttana.new2old /data/random_graph_undirec.txt.cuttana.cuttana256.P16.tmp /data/random_graph_undirec.txt.cuttana.cuttana256.P16
