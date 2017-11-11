SetActiveLib -work
comp -include "$dsn\src\task 2\controller_device.vhd" 
comp -include "$dsn\src\test-bench\task 2\count_zeros\count_zeros.vhd" 
asim +access +r count_zeros 

wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop
wave -virtual result UDEVICE/URAM/ram_storage(6)
wave -virtual array "UDEVICE/URAM/ram_storage(1 to 5)"

run 1 us