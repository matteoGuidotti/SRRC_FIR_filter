create_clock -period 25.000 -name clock -waveform {0.000 12.500} [list [get_ports clk] [get_ports clk]]

