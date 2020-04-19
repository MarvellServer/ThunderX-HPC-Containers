set nrowmax 8
gold.N320.sys

set xc PBE
set ecut 130
set nempty 544
set fermi_temp 500.0
set wf_dyn PSDA
set ecutprec 8.0

set charge_mix_rcut 3.0
set charge_mix_coeff 0.8

kpoint 0.0000001 0 0 1.0

randomize_wf
run 0 1 3

quit
