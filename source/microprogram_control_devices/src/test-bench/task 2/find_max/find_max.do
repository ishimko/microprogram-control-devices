SetActiveLib -work
comp -include "$dsn\src\task 2\controller_device.vhd" 
comp -include "$dsn\src\test-bench\task 2\find_max\find_max.vhd" 
asim +access +r find_max 

wave 
wave -noreg CLK
wave -noreg RST
wave -noreg Start
wave -noreg Stop
wave -virtual result /find_max/UDEVICE/URAM/ram_storage(6)
wave -virtual array "/find_max/UDEVICE/URAM/ram_storage(1 to 5)"

run 2 us