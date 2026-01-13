#!/bin/bash
set -e

docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-papers100M.directed.cuttana -p 2 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-papers100M.directed.cuttana.new2old /data/ogbn-papers100M.directed.cuttana.cuttana256.P2.tmp /data/ogbn-papers100M.directed.cuttana.cuttana256.P2.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-papers100M.directed.cuttana -p 4 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-papers100M.directed.cuttana.new2old /data/ogbn-papers100M.directed.cuttana.cuttana256.P4.tmp /data/ogbn-papers100M.directed.cuttana.cuttana256.P4.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-papers100M.directed.cuttana -p 8 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-papers100M.directed.cuttana.new2old /data/ogbn-papers100M.directed.cuttana.cuttana256.P8.tmp /data/ogbn-papers100M.directed.cuttana.cuttana256.P8.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-papers100M.directed.cuttana -p 16 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-papers100M.directed.cuttana.new2old /data/ogbn-papers100M.directed.cuttana.cuttana256.P16.tmp /data/ogbn-papers100M.directed.cuttana.cuttana256.P16.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-papers100M.directed.cuttana -p 32 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-papers100M.directed.cuttana.new2old /data/ogbn-papers100M.directed.cuttana.cuttana256.P32.tmp /data/ogbn-papers100M.directed.cuttana.cuttana256.P32.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-arxiv.directed.cuttana -p 2 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-arxiv.directed.cuttana.new2old /data/ogbn-arxiv.directed.cuttana.cuttana256.P2.tmp /data/ogbn-arxiv.directed.cuttana.cuttana256.P2.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-arxiv.directed.cuttana -p 4 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-arxiv.directed.cuttana.new2old /data/ogbn-arxiv.directed.cuttana.cuttana256.P4.tmp /data/ogbn-arxiv.directed.cuttana.cuttana256.P4.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-arxiv.directed.cuttana -p 8 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-arxiv.directed.cuttana.new2old /data/ogbn-arxiv.directed.cuttana.cuttana256.P8.tmp /data/ogbn-arxiv.directed.cuttana.cuttana256.P8.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-arxiv.directed.cuttana -p 16 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-arxiv.directed.cuttana.new2old /data/ogbn-arxiv.directed.cuttana.cuttana256.P16.tmp /data/ogbn-arxiv.directed.cuttana.cuttana256.P16.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-arxiv.directed.cuttana -p 32 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-arxiv.directed.cuttana.new2old /data/ogbn-arxiv.directed.cuttana.cuttana256.P32.tmp /data/ogbn-arxiv.directed.cuttana.cuttana256.P32.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-products.directed.cuttana -p 2 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-products.directed.cuttana.new2old /data/ogbn-products.directed.cuttana.cuttana256.P2.tmp /data/ogbn-products.directed.cuttana.cuttana256.P2.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-products.directed.cuttana -p 4 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-products.directed.cuttana.new2old /data/ogbn-products.directed.cuttana.cuttana256.P4.tmp /data/ogbn-products.directed.cuttana.cuttana256.P4.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-products.directed.cuttana -p 8 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-products.directed.cuttana.new2old /data/ogbn-products.directed.cuttana.cuttana256.P8.tmp /data/ogbn-products.directed.cuttana.cuttana256.P8.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-products.directed.cuttana -p 16 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-products.directed.cuttana.new2old /data/ogbn-products.directed.cuttana.cuttana256.P16.tmp /data/ogbn-products.directed.cuttana.cuttana256.P16.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/ogbn-products.directed.cuttana -p 32 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/ogbn-products.directed.cuttana.new2old /data/ogbn-products.directed.cuttana.cuttana256.P32.tmp /data/ogbn-products.directed.cuttana.cuttana256.P32.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/reddit.directed.cuttana -p 2 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/reddit.directed.cuttana.new2old /data/reddit.directed.cuttana.cuttana256.P2.tmp /data/reddit.directed.cuttana.cuttana256.P2.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/reddit.directed.cuttana -p 4 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/reddit.directed.cuttana.new2old /data/reddit.directed.cuttana.cuttana256.P4.tmp /data/reddit.directed.cuttana.cuttana256.P4.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/reddit.directed.cuttana -p 8 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/reddit.directed.cuttana.new2old /data/reddit.directed.cuttana.cuttana256.P8.tmp /data/reddit.directed.cuttana.cuttana256.P8.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/reddit.directed.cuttana -p 16 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/reddit.directed.cuttana.new2old /data/reddit.directed.cuttana.cuttana256.P16.tmp /data/reddit.directed.cuttana.cuttana256.P16.vid2pid
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./ogpart -d /data/reddit.directed.cuttana -p 32 -subp 256 -b 1.05 -vb 1 -directed
docker run --rm -v /data/sdb/nikolai/gnn-partitioner/edgelists:/data cuttana ./partition_to_original /data/reddit.directed.cuttana.new2old /data/reddit.directed.cuttana.cuttana256.P32.tmp /data/reddit.directed.cuttana.cuttana256.P32.vid2pid
