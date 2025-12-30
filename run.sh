#!/bin/bash
set -e

docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./edgelist_to_cuttana /data/directed.edgelist
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.cuttana -p 2 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.cuttana.new2old /data/directed.edgelist.cuttana.cuttana256.P2.tmp /data/directed.edgelist.cuttana.cuttana256.P2
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.cuttana -p 4 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.cuttana.new2old /data/directed.edgelist.cuttana.cuttana256.P4.tmp /data/directed.edgelist.cuttana.cuttana256.P4
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.cuttana -p 8 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.cuttana.new2old /data/directed.edgelist.cuttana.cuttana256.P8.tmp /data/directed.edgelist.cuttana.cuttana256.P8
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.cuttana -p 16 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.cuttana.new2old /data/directed.edgelist.cuttana.cuttana256.P16.tmp /data/directed.edgelist.cuttana.cuttana256.P16
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./ogpart -d /data/directed.edgelist.cuttana -p 32 -subp 256 -b 1.05 -vb 1
docker run --rm -v /Users/nikolaimerkel/development/TUB/partitioning/cuttana-partitioner/input:/data cuttana ./partition_to_original /data/directed.edgelist.cuttana.new2old /data/directed.edgelist.cuttana.cuttana256.P32.tmp /data/directed.edgelist.cuttana.cuttana256.P32
