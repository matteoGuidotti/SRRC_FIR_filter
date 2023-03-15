# check the errors of the hardware simulation with the respect to the software computation

input_file = "hw_sim_results/simulation_input.lst"
output_file = "hw_sim_results/simulation_output.lst"
sw_simulation_file = "fir_simulation_output.txt"
results_comparison_file = "hw_sim_results/results_comparison.txt"
# resulting LSB of the hardware output
output_LSB = pow(2, -12)


def read_hw_sim_results():
    txt_file = open(input_file, "r")
    input_lines = txt_file.readlines()
    txt_file.close()
    txt_file = open(output_file, "r")
    output_lines = txt_file.readlines()
    txt_file.close()
    input_values = []
    output_values = []
    for line in input_lines:
        if line[0] != '@':
            input_values.append(line.split(" ")[1])
    for line in output_lines:
        if line[0] != '@':
            output_values.append(line.split(" ")[1])
    return {'input': input_values, 'output': output_values}


if __name__ == "__main__":
    file = open(sw_simulation_file, "r")
    sw_results = file.readlines()
    file.close()
    hw_output = read_hw_sim_results()["output"]
    # get only the output of the simulation in order to compare one to each other (they are ordered in the same way)
    sw_output = []
    error_sum = []
    for line in sw_results:
        output = line.split(":")
        # the last line contains only the output so it must not be splitted
        sw_output.append(line.split(":")[len(output) - 1])
    file = open(results_comparison_file, "w")
    for i in range(0, len(hw_output)):
        file.write("HW = " + str(float(hw_output[i]) * output_LSB) + " <-> SW = " + str(float(sw_output[i])) + "\n\n")
        error_sum = abs(float(hw_output[i]) * output_LSB - float(sw_output[i]))
    file.close()
    print("The mean error value is " + str(error_sum/len(hw_output)))
