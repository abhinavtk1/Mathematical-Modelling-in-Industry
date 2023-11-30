# Algorithm to simulate a Continuous-time Markov Chain
import numpy as np

def simulate_poisson_process(rate, sim_time):
    curr_time = 0
    curr_state = 0
    statelist = [curr_state]
    timelist = [curr_time]

    while curr_time < sim_time:
        # Generate time increment until the next event
        time_increment = np.random.exponential(scale=1/rate)
        curr_time += time_increment

        # Generate a random transition
        transition_prob = np.random.rand()
        if transition_prob < 0.5:  # Example: 2 states
            curr_state = 0 if curr_state == 1 else 1

        statelist.append(curr_state)
        timelist.append(curr_time)

    return statelist, timelist

# Set parameters
rate_parameter = 0.5  # Adjust the rate parameter as needed
simulation_time = 10  # Adjust simulation time as needed

# Simulate the Poisson process
states, times = simulate_poisson_process(rate_parameter, simulation_time)

# Print the simulated states and corresponding times
print("Simulated States:", states)
print("Corresponding Times:", times)
