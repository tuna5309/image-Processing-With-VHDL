onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+c_shift_ram_0 -L xbip_utils_v3_0_10 -L c_reg_fd_v12_0_6 -L c_mux_bit_v12_0_6 -L c_shift_ram_v12_0_13 -L xil_defaultlib -L secureip -O5 xil_defaultlib.c_shift_ram_0

do {wave.do}

view wave
view structure

do {c_shift_ram_0.udo}

run -all

endsim

quit -force
