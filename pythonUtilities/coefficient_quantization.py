# ----------------------------------------------------------------------------------------------------------------------
# quantization of the coefficients of the filter, printed into coefficients.txt
# thanks to the simmetry I can use a vector of a half of the number of coefficients
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

import math

coeff_number = 23
LSB = pow(2, -14)
c = [-0.0165, -0.015, 0.0155, 0.0424, 0.0155, -0.0750, -0.1568, -0.1061, 0.1568, 0.5786, 0.9745, 1.1366]
q = list(range(0, coeff_number))


def coefficient_quantization(printToCode):
    count = 0
    for coeff in c:
        q[count] = q[coeff_number - 1 - count] = math.floor(coeff / LSB)
        count += 1
    if printToCode:
        file = open("coefToCode.txt", "w")
        for i in range(0, 12):
            if i < 11:
                file.write("to_signed(" + str(q[i]) + ", 16),\n")
            else:
                file.write("to_signed(" + str(q[i]) + ", 16)")
    else:
        file = open("coefficients.txt", "w")
        for coeff in q:
            file.write(str(coeff) + "\n")
        file.close()


def quantization_error():
    sum = 0
    for i in range(0, coeff_number):
        if i <= 11:
            sum += q[i] * LSB - c[i]
        else:
            sum += q[i] * LSB - c[coeff_number - i - 1]
    return sum/coeff_number


if __name__ == "__main__":
    coefficient_quantization(True)
    print(abs(quantization_error()))
