import math
import scipy as sp
import sympy as sy
from sympy.physics.control.lti import StateSpace


#======================================
#               COSTANTS
#======================================

k1 = 1.00
k2 = 0.30
k3 = 0.45
k4 = 0.50
ae = sy.Matrix([9.45, 4.20])



ue = (k1*(ae[0]**0.5))/k4
print(sy.pretty(ue))


#definizione variabili simboliche e funzioni di stato e uscita

x1, x2, u, s = sy.symbols('x1 x2 u s')
f1 = -k1*(x1)**0.5+k4*u
f2 = k2*(x1)**0.5-k3*(x2)**0.5
y = x2

#======================================
#           LINEARIZATION
#======================================

function  = sy.Matrix([[-k1*(ae[0]**0.5) + k4*ue],
               [ k2*(ae[0]**0.5) - k3*(ae[1]**0.5)]])


A = sy.Matrix([f1, f2]).jacobian([x1, x2])

B = sy.Matrix([f1, f2]).jacobian([u])

C = sy.Matrix([y]).jacobian([x1,x2])

D = sy.Matrix([y]).jacobian([u])

punto_equilibrio = {x1:9.45, x2:4.20, u:ue}

A_eq = A.subs(punto_equilibrio)
B_eq = B.subs(punto_equilibrio)
C_eq = C.subs(punto_equilibrio)
D_eq = D.subs(punto_equilibrio)

print("\nMatrice A: ")
print(sy.pretty(A_eq))
print("\nMatrice B: ")
print(sy.pretty(B_eq))
print("\nMatrice C: ")
print(sy.pretty(C_eq))
print("\nMatrice D: ")
print(sy.pretty(D_eq))

#======================================
#           STATE SPACE
#======================================

ss = StateSpace(A_eq, B_eq, C_eq, D_eq)

#======================================
#           TRANSFER FUNCTION
#======================================
I = sy.eye(A_eq.shape[0])
print("\nFunzione di trasferimento: ")
tf = C_eq*(s*I-A_eq).inv()*B_eq + D_eq


print(sy.pretty(tf))


