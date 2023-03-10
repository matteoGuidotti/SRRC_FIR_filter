# ----------------------------------------------------------------------------------------------------------------------
# simulation of the calculus that the SRRC FIR must compute
# Order of the filter: 22
# Roll-Off factor: 0.5
# Samples per symbol: 4
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

import signal_generator as sg

# coefficients
c = [-0.0165, -0.015, 0.0155, 0.0424, 0.0155, -0.0750, -0.1568, -0.1061, 0.1568, 0.5786, 0.9745, 1.1366,
     0.9745, 0.5786, 0.1568, -0.1061, -0.1568, -0.0750, 0.0155, 0.0424, 0.0155, -0.015, -0.0165]


def shift_positions(signals):
    for i in range(0, 23):
        signals[i] = signals[i-1]


def compute_fir(signals):
    sum = 0
    for i in range(0, 23):
        sum += signals[i] * c[i]
    return sum


if __name__ == "__main__":
    signals = []
    countOutput = 0
    # reset simulation
    for i in range(0, 23):
        signals.append(0)
    while True:
        shift_positions(signals)
        signals[0] = sg.signal_gereator()
        output = compute_fir(signals)
        file = open("output.txt", "w")
        file.write(str(countOutput) + ": " + str(output))
        file.close()
