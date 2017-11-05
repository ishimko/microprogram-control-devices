SetActiveLib -work
comp -include "$dsn\src\task 1\TrafficLight.vhd" 
comp -include "$dsn\src\test-bench\task 1\trafficlight_TB.vhd" 
asim +access +r trafficlight_tb 
wave 
wave -noreg clk
wave -noreg cwait
wave -noreg rst
wave -noreg start
wave -noreg r
wave -noreg y
wave -noreg g

run
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\test-bench\trafficlight_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_trafficlight 
