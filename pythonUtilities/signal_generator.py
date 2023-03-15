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


# print_to_code is a boolean variable
# if it's true the result is printed to a file in order to copy and past the content to the vhd file code
# if it's false the values are printed as they are in a txt file
def quantized_signal(print_to_code):
    signal_values = signal_generator(2*np.pi, 100)
    if print_to_code:
        file = open("signal_to_code.txt", "w")
    else:
        file = open("quantized_signal.txt", "w")
    q = []
    # in case print_to_code is true, the values will be encoded in a vhd case statement starting from the "when 2" line
    case_count = 2
    for signal in signal_values:
        print(float(signal) / LSB)
        quantized_value = math.floor(float(signal) / LSB)
        q.append(quantized_value)
        # print quantized_value where I need to print it
        if print_to_code:
            # in order to insert the value in the vhd code, I need to convert it to a 16 bit two's complement binary
            file.write("when " + str(case_count) + " => x_tb <= \"" + bc.signed_to_binary(quantized_value) + "\";\n")
            case_count += 1
        else:
            file.write(str(quantized_value) + "\n")
    file.close()
    error = 0
    for i in range(0, signal_values.size):
        error += q[i] * LSB - signal_values[i]
    print("quantization error: " + str(abs(error/signal_values.size)))


if __name__ == "__main__":
    quantized_signal(False)
