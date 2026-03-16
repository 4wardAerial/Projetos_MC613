transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1\ -\ Vending\ Machine {/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1 - Vending Machine/bin11_to_bcd4.v}
vlog -vlog01compat -work work +incdir+/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1\ -\ Vending\ Machine {/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1 - Vending Machine/bin11_to_bcd4_tb.v}

vlog -vlog01compat -work work +incdir+/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1\ -\ Vending\ Machine {/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1 - Vending Machine/bin11_to_bcd4.v}
vlog -vlog01compat -work work +incdir+/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1\ -\ Vending\ Machine {/home/f-ec2024/ra281289/Documents/Projetos_MC613/P1 - Vending Machine/bin11_to_bcd4_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  bin11_to_bcd4_tb

add wave *
view structure
view signals
run -all
