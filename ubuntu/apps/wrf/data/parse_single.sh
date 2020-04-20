#!/usr/bin/env bash
# $1 is the dir to parse

STATS=/docker/run/stats.awk
GFLOPS=/docker/run/calc_gflops.py

# Step 1: Get timing stats
pushd $1 &> /dev/null
[[ ! -f "result_stats.txt" && -f "./rsl/rsl.error.0000" ]] && grep 'Timing for main' ./rsl/rsl.error.0000 | tail -149 | awk '{print $9}' | awk -f ${STATS} > result_stats.txt

# Step 2: Calculate GFlops
[[ ! -f "result_gflops.txt" && -f "result_stats.txt" ]] && python3 ${GFLOPS} "$(cat result_stats.txt | grep mean: | awk '{print $2}')" > result_gflops.txt
popd &> /dev/null

echo "All done."
