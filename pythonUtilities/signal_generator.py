# ----------------------------------------------------------------------------------------------------------------------
# Signal generator for a filter
# Signal has a sin waveform
# The sin values are calculated for frequencies between 0 and the period of the sin function
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

import math
import numpy as np
import matplotlib.pyplot as plt
import binary_conversion as bc

# LSB for the computation of the quantized values of the signal
LSB = pow(2, -15)


# compute and return sin function of num_of_frequencies frequencies between 0 and period with the same step
def signal_generator(period, num_of_frequencies):
    freqs = np.linspace(0, period, num_of_frequencies)
    signal_values = np.sin(freqs)
    # plt.plot(freqs, signal_values)
    # plt.title("NUMPY")
    # plt.show()
    return signal_values


# The result is printed to a file in order to copy and paste the content to the vhd file code
# The values are also printed as they are in a txt file
def quantized_signal():
    signal_values = signal_generator(2 * np.pi, 100)
    file_to_code = open("input_signal/signal_to_code.txt", "w")
    file_signal = open("input_signal/quantized_signal.txt", "w")
    q = []
    # The values will be encoded in a vhd case statement starting from the "when 2" line
    case_count = 2
    for signal in signal_values:
        quantized_value = math.floor(float(signal) / LSB)
        q.append(quantized_value)
        # in order to insert the value in the vhd code, I need to convert it to a 16 bit two's complement binary
        file_to_code.write(
            "when " + str(case_count) + " => x_tb <= \"" + bc.signed_to_binary(quantized_value) + "\";\n")
        case_count += 1
        file_signal.write(str(quantized_value) + "\n")
    file_signal.close()
    file_to_code.close()
    error = 0
    for i in range(0, signal_values.size):
        error += abs(q[i] * LSB - signal_values[i])
    print("quantization error: " + str(error / signal_values.size))


if __name__ == "__main__":
    quantized_signal()
