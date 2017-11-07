SetActiveLib -work
comp -include "$dsn\src\task 2\controller_device.vhd" 
comp -include "$dsn\src\test-bench\task 2\find_max.vhd" 
asim +access +r find_max 

wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop
wave /find_max/UDEVICE/URAM/*
wave /find_max/UDEVICE/UCTRL/*

run 1 us