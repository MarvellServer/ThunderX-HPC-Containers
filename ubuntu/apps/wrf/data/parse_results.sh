#!/usr/bin/env bash
# Just run this script, it'll go through all smt* directories

STATS=$(pwd)/stats.awk
GFLOPS=$(pwd)/calc_gflops.py
DIFFWRF=/mnt/nas/benchmarks/wrf/conus_data/bench_12km/diffwrf-nogui.py
REFDATA=/mnt/nas/benchmarks/wrf/conus_data/bench_12km/wrfout_d01_2001-10-24_12:00:00-ORIG
while read -r line; do
    echo "Processing ${line}"
    # Step 1: Get timing stats
    pushd ${line} &> /dev/null
    [[ ! -f "result_stats.txt" && -f "./rsl/rsl.error.0000" ]] && grep 'Timing for main' ./rsl/rsl.error.0000 | tail -149 | awk '{print $9}' | awk -f ${STATS} > result_stats.txt
    # Step 2: Calculate GFlops
    [[ ! -f "result_gflops.txt" && -f "result_stats.txt" ]] && python3 ${GFLOPS} "$(cat result_stats.txt | grep mean: | awk '{print $2}')" > result_gflops.txt
    # Step 3: Compute diff with reference wrf data
    if [[ ! -d "diffwrf" ]]; then
        mkdir -p diffwrf
        WRFDATA=$(pwd)/wrfout_d01_2001-10-24_12:00:00
        pushd diffwrf &> /dev/null
        python ${DIFFWRF} ${WRFDATA} ${REFDATA} > diffout.txt
        popd &> /dev/null
    fi
    popd &> /dev/null
done <<< $(find ./ -type d -name "smt*")
echo "All done."
