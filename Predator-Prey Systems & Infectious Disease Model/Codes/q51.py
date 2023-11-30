## Infectious disease Model ##
# Eq point 1

from sympy import symbols, Eq, solve
import random

# Define the variables
# F: Antibody, V: Antigen, C: Plasma cells, M: Organ
F, V, C, M = symbols('F V C M', real=True, positive=True)
alpha, beta, gamma, mu, sigma, eta = symbols('alpha beta gamma mu sigma eta', real=True, positive=True)
a, p, k = symbols('a p k', real=True, positive=True)
Cstar = symbols('Cstar', real=True, positive=True)

# Define the equations
V_dash = Eq(alpha*V - p*V*F, 0)
F_dash = Eq(beta*C - gamma*p*V*F - a*F, 0)
C_dash = Eq(-mu*(C - Cstar) + k*V*F, 0)
M_dash = Eq(alpha*V - eta*M,0)

V_dash = V_dash.subs({V: 0})
M_dash = M_dash.subs({M: 0})
C_dash = V_dash.subs({C: Cstar, V:0})
F_dash = F_dash.subs({C: Cstar, V:0})

# Find equilibrium points by solving the system of equations
equilibrium_points = solve((V_dash, M_dash, C_dash, F_dash), (V, M, C, F))

print("Equilibrium Points:")
print(equilibrium_points)
