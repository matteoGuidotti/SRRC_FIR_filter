# ----------------------------------------------------------------------------------------------------------------------
# Signal generator for a filter
# Signal has a sin waveform
# The sin values are calculated for frequencies between 0 and the period of the sin function
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

import numpy as np
import matplotlib.pyplot as plt


# def signal_generator_mio():
#    value_list = []
#    step = period/fraction
#    freq = 0
#    freqs = []
#    while freq <= period:
#        value_list.append(math.sin(freq))
#        freqs.append(freq)
#        freq += step
#    plt.plot(freqs, value_list)
#    plt.title("MIO")
#    plt.show()
#    return value_list


def signal_generator(period, num_of_frequencies):
    # compute 100 frequencies between 0 and 2*pi with the same step
    freqs = np.linspace(0, period, num_of_frequencies)
    signal_values = np.sin(freqs)
    # plt.plot(freqs, signal_values)
    # plt.title("NUMPY")
    # plt.show()
    return signal_values


def quantized_signal():
    signal_values = signal_generator()



if __name__ == "__main__":
    signal_generator()
