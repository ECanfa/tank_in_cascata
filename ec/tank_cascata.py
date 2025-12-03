import math
import numpy as np
import scipy as sp
import matplotlib.pyplot as plt
import sympy as sy
from sympy.physics.control.lti import StateSpace
k1 = 1.00
k2 = 0.30
k3 = 0.45
k4 = 0.50
ae = np.array([9.45, 4.20])

# Linearizzazione intorno al punto di equilibro
# (ae, ue)
# 
ue = (k1*(ae[0]**0.5))/k4
print(ue)

function  = np.round( np.array([[-k1*(ae[0]**0.5) + k4*ue],
               [ k2*(ae[0]**0.5) - k3*(ae[1]**0.5)]]), 2)

x1, x2, u, s = sy.symbols('x1 x2 u s')
f1 = -k1*(x1)**0.5+k4*u
f2 = k2*(x1)**0.5-k3*(x2)**0.5
y = 0*x1 +x2

assert np.equal(function, np.zeros(np.shape([2, 1]))).all()

A2 = sy.Matrix([
     [sy.diff(f1, var) for var in [x1,x2]],
      [sy.diff(f2, var) for var in [x1, x2]]])

B2 = sy.Matrix([
        [sy.diff(f1, u)],
        [sy.diff(f2,u)]])
C2 = sy.Matrix([sy.diff(y, var) for var in [x1,x2]]).T

D2 = sy.Matrix([sy.diff(y,u)])
punto_equilibrio = {x1:9.45, x2:4.20, u:ue}

A_eq = A2.subs(punto_equilibrio)
B_eq = B2.subs(punto_equilibrio)
C_eq = C2.subs(punto_equilibrio)
D_eq = D2.subs(punto_equilibrio)

print(A_eq)
print(B_eq)
print(C_eq)
print(D_eq)

try:
    ss = StateSpace(A_eq, B_eq, C_eq, D_eq)

#======================================
#           TRANSFER FUNCTION
#======================================
    I = sy.eye(A_eq.shape[0])
    tf = C_eq*(s*I-A_eq).inv()*B_eq + D_eq
except TypeError:
    print("Matrice errata o infinita")
    exit(-1)

print(tf)
#print(tf.num)
#print(tf.den)

