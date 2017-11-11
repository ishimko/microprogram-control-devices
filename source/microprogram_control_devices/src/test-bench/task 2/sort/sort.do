SetActiveLib -work
comp -include "$dsn\src\task 2\controller_device.vhd" 
comp -include "$dsn\src\test-bench\task 2\sort\sort.vhd" 
asim +access +r sort 

wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop
wave -virtual array "UDEVICE/URAM/ram_storage(6 to 10)"

run 15 us