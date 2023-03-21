# ----------------------------------------------------------------------------------------------------------------------
# Function to convert values from signed decimal to two's complement binary on 16 bits
# ----------------------------------------------------------------------------------------------------------------------
# Author: Guidotti Matteo
# ----------------------------------------------------------------------------------------------------------------------

# converts val (decimal signed) in its two's complement binary representation on 16 bits
def signed_to_binary(val):
    if val < 0:
        res = bin(pow(2, 16) - abs(val))[2:]
        extended_bit = "1"
    else:
        res = bin(val)[2:]
        extended_bit = "0"
    # each value must be extended to 16 bits
    bit_len = len(res)
    bit_to_add = 16 - bit_len
    while bit_to_add > 0:
        res = extended_bit + res
        bit_to_add -= 1
    return res
