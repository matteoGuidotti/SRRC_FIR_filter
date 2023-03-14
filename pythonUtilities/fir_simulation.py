# ----------------------------------------------------------------------------------------------------------------------
# simulation of the calculus that the SRRC FIR must compute
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
    for i in range(0, 23):
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
    countOutput = 0
    # reset simulation
    for i in range(0, 23):
        signal_values.append(0)
    # get the sin signal values
    sin_values = sg.signal_generator(period, num_of_frequencies)
    file = open("output.txt", "w")
    for signal in sin_values:
        shift_positions(signal_values)
        signal_values[0] = signal
        output = compute_fir(signal_values)
        file.write(str(countOutput) + ": " + str(output) + "\n")
        countOutput += 1
    file.close()
