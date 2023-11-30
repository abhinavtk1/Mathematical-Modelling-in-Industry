from sympy import symbols, Eq, solve
import random

# Define the variables
n1, n2, n3, n4 = symbols('n1 n2 n3 n4', real=True, positive=True)
k, c1, c2, c3, c4 = symbols('k c1 c2 c3 c4', real=True, positive=True)
d1, d2, d3, d4 = symbols('d1 d2 d3 d4', real=True, nonnegative=True)
e1, e2, e3 = symbols('e1 e2 e3', real=True, nonnegative=True)
f2 = symbols('f2', real=True, nonnegative=True)
print("Check point 1")
# Assign numerical values or ranges to the parameters
k_value = 1000  # Example value for carrying capacity
c1_value = random.uniform(0.1, 2.0)  # Example range for growth rate c1
c2_value = random.uniform(0.1, 2.0)
c3_value = random.uniform(0.1, 2.0)
d1_value = random.uniform(0.01, 1.0) 
d2_value = random.uniform(0.01, 1.0)
d3_value = random.uniform(0.01, 1.0)
d4_value = random.uniform(0.01, 1.0)
e1_value = random.uniform(0.01, 1.0)
e3_value = random.uniform(0.01, 1.0)
f2_value = random.uniform(0.01, 1.0)
e2_value = random.uniform(0.1, 0.5) # Symbiotic relationship
c4_value = random.uniform(0.1, 2.0)
# Define other parameter values or ranges similarly
print("Check point 2")
# Define the equations for Four-Species Model
n1_dash = Eq(c1 * n1 * (1 - n1 / k) - d1 * n1 * n2 - e1 * n1 * n3, 0)
n2_dash = Eq(c2 * n1 * n2 - d2 * n2 + e2 * n2 * n4 - f2 * n2 * n3, 0)
n3_dash = Eq(c3 * n3 * n1 + d3 * n3 * n2 - e3 * n3, 0)
n4_dash = Eq(c4 * n2 * n4 - d4 * n4, 0)
print("Check point 3")
# Substitute numerical values into the equations
n1_dash = n1_dash.subs({k: k_value, c1: c1_value, c2: c2_value, c3: c3_value, c4: c4_value, d1: d1_value, d2: d2_value, d3: d3_value, d4: d4_value, e1: e1_value, e2: e2_value, e3: e3_value, f2: f2_value})  # Substitute other parameters similarly
print("Check point 4")
# Find equilibrium points by solving the system of equations
equilibrium_points = solve((n1_dash, n2_dash, n3_dash, n4_dash), (n1, n2, n3, n4))
print("Check point 5")