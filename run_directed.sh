#!/bin/bash
set -e

docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./directed_edgelist_to_directed_cuttana /data/directed.edgelist
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.directed.cuttana -p 2 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.directed.cuttana.new2old /data/directed.edgelist.directed.cuttana.cuttana256.P2.tmp /data/directed.edgelist.directed.cuttana.cuttana256.P2
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.directed.cuttana -p 4 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.directed.cuttana.new2old /data/directed.edgelist.directed.cuttana.cuttana256.P4.tmp /data/directed.edgelist.directed.cuttana.cuttana256.P4
