# ----------------------------------------------------------------------------------------------------------------------
# Quantization of the coefficients of the filter, printed into coefficients.txt
# Thanks to the simmetry I can use a vector of a half of the number of coefficients
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

import math

# number of coefficients
coeff_number = 23
# LSB used to quantize the coefficients
LSB = pow(2, -14)
c = [-0.0165, -0.015, 0.0155, 0.0424, 0.0155, -0.0750, -0.1568, -0.1061, 0.1568, 0.5786, 0.9745, 1.1366]
q = list(range(0, coeff_number))


# The result is printed to a file in order to copy and paste the content to the vhd file code
# The coefficients are also printed as they are in a txt file
def coefficient_quantization():
    count = 0
    for coeff in c:
        q[count] = q[coeff_number - 1 - count] = math.floor(coeff / LSB)
        count += 1
    file = open("coefficients/coefToCode.txt", "w")
    for i in range(0, 12):
        if i < 11:
            file.write("to_signed(" + str(q[i]) + ", 16),\t-- (" + str(c[i]) + ")\n")
        else:
            file.write("to_signed(" + str(q[i]) + ", 16)\t-- (" + str(c[i]) + ")")
    file.close()
    file = open("coefficients/coefficients.txt", "w")
    for coeff in q:
        file.write(str(coeff) + "\n")
    file.close()


# compute and return the quantization error for the coefficients
def quantization_error():
    sum = 0
    for i in range(0, coeff_number):
        if i <= 11:
            sum += abs(q[i] * LSB - c[i])
        else:
            sum += abs(q[i] * LSB - c[coeff_number - i - 1])
    return sum/coeff_number


if __name__ == "__main__":
    coefficient_quantization()
    print(quantization_error())
