# ----------------------------------------------------------------------------------------------------------------------
# Simulation of the calculus that the SRRC FIR must compute
# Order of the filter: 22
# Roll-Off factor: 0.5
# Samples per symbol: 4
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

import numpy as np
import signal_generator as sg

# coefficients
c = [-0.0165, -0.015, 0.0155, 0.0424, 0.0155, -0.0750, -0.1568, -0.1061, 0.1568, 0.5786, 0.9745, 1.1366,
     0.9745, 0.5786, 0.1568, -0.1061, -0.1568, -0.0750, 0.0155, 0.0424, 0.0155, -0.015, -0.0165]

# number of frequencies for which the sin function is computed between 0 and the period
num_of_frequencies = 100
period = 2*np.pi


# shift the position of each signal sample to the next one
def shift_positions(values):
    for i in range(22, 0, -1):
        values[i] = values[i - 1]


# compute the result of the fir for the values passed as arguments
def compute_fir(values):
    sum = 0
    for i in range(0, 23):
        sum += values[i] * c[i]
    return sum


if __name__ == "__main__":
    # list of 23 values that are used to compute the result
    signal_values = []
    # reset simulation
    for i in range(0, 23):
        signal_values.append(0)
    # get the sin signal values
    sin_values = sg.signal_generator(period, num_of_frequencies)
    file = open("hw_sim_results/fir_sw_simulation_output.txt", "w")
    old_output = 0
    for signal in sin_values:
        shift_positions(signal_values)
        signal_values[0] = signal
        output = compute_fir(signal_values)
        # given the fact that in the hw simulation the output is delayed with the respect of the input, I'll print
        # them in the same way to make the comparison easier
        # Input:Output at the same clock
        file.write(str(signal) + ":" + str(old_output) + "\n")
        old_output = output
    # last output has not an associated input, given that it is delayed
    file.write(str(old_output))
    file.close()
