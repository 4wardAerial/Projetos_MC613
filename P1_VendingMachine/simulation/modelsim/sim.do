vlog ../../*.v
vsim work.vending_machine_tb
add wave -position end  sim:/vending_machine_tb/clk
add wave -position end  sim:/vending_machine_tb/sw
add wave -position end  sim:/vending_machine_tb/key
add wave -position end  sim:/vending_machine_tb/ledr
add wave -position end  sim:/vending_machine_tb/uut/state
add wave -position end  sim:/vending_machine_tb/uut/add_prod/PROD_NUM
add wave -position end  sim:/vending_machine_tb/uut/displayer/prod_value_bin
run -all