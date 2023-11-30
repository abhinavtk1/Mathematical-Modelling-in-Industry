import numpy as np

def transition_pMat(p):
    # Transition probability for the given problem
    Pmat = np.array([[1-p, 0, p, 0],
                    [1-p, 0, p, 0],
                    [0, 1-p, 0, p],
                    [0, 1-p, 0, p]])
    return Pmat

#  A general script that evaluates whether a given Markov chain converges to steadystate or not
def markov_chain_simulation(p, initial_state, iter=10000, tolerance=1e-8):
    # Initialize the transition matrix using input probability p
    transition_pmatrix = transition_pMat(p)
    state_probabilities = np.zeros((iter, 4))     # Initialize the state probabilities
    state_probabilities[0][initial_state] = 1-p         # Setting initial state probability
    
    # Simulating the Markov chain
    for i in range(1, iter):
        state_probabilities[i] = np.dot(state_probabilities[i - 1],transition_pmatrix)

        # Convergence check
        if np.max(np.abs(state_probabilities[i] - state_probabilities[i - 1])) < tolerance:
            return state_probabilities[:i + 1], i + 1
    
    return state_probabilities, iter

# Setting the parameters
p_value = 0.7  # p value for the transition matrix
initial_state = 0  # Initial state

# Markov chain simulation and checking for convergence
probability, iterations = markov_chain_simulation(p_value, initial_state)

if iterations < 10000:
    print("Steady-state probabilities for p = {p_value}".format(p_value=p_value))
    print(probability[-1])
    print("The Markov chain converged to steady state in {} iterations.".format(iterations))
else:
    print("The Markov chain could not converge to steady-state for the given iterations.")