import sympy as sy
import scipy as sp
import matplotlib.pyplot as plt
from sympy.physics.control.lti import TransferFunction
from sympy.physics.control.control_plots import bode_plot

k1  = 1.
k2  = 0.30
k3  = 0.45
k4  = 0.50
ae1 = 9.45
ae2 = 4.20

# Linearizzazione intorno al punto di equilibro
# (ae, ue)
# 
# TODO aggiorna
ue = (k1*(ae1**0.5))/k4

x1, x2, u, s = sy.symbols('x1 x2 u s')
s = sy.symbols('s',complex=True)
t = sy.symbols('t')

f1 = -k1*(x1)**0.5+k4*u
f2 = k2*(x1)**0.5-k3*(x2)**0.5
y = 0*x1 +x2

A2 = sy.Matrix([
     [sy.diff(f1, var) for var in [x1,x2]],
     [sy.diff(f2, var) for var in [x1,x2]]
    ])

B2 = sy.Matrix([
        [sy.diff(f1, u)],
        [sy.diff(f2,u)]
    ])

C2 = sy.Matrix([sy.diff(y, var) for var in [x1,x2]]).T

D2 = sy.Matrix([sy.diff(y,u)])

punto_equilibrio = {x1:9.45, x2:4.20, u:ue}

A_eq = A2.subs(punto_equilibrio)
B_eq = B2.subs(punto_equilibrio)
C_eq = C2.subs(punto_equilibrio)
D_eq = D2.subs(punto_equilibrio)
#print(A_eq)
#print(B_eq)
#print(C_eq)
#print(D_eq)

I  = sy.eye(2)
H  = C_eq*(s*I-A_eq).inv()*B_eq + D_eq
(num, den) = H[0].as_numer_denom()
tf = TransferFunction(num, den, s)

poles = tf.poles()

#TODO
#wrapper function per matplotlib
#forse sarebbe meglio se ne facessimo una noi
#per cambiare la grafica
# bode_plot(tf, initial_exp=0.2, final_exp=0.7)

# 
# L(jw) Funzione ad anello aperto
# Analisi Statica
#

# Risposta statica del sistema a d(t) e w(t) in forma Canonica
# S(s) funzione di trasferimento che mette in relazione w(t),d(t) con e(t)
# S(s) = 1/ 1+ L(s)
# lim_s->0 L(s) = u / s^g
# Per Teorema del Valore Finale lim_t->0 e(t) = lim_s->0 E(s) = AS(s) = A*(s^g / u + s^g)

# ===================
# e_star = 0.01
# W <= 3.5
# D <= 2.5
# ===================

# TODO: sostituire laplace_transform con il valore statico
#       non c'e bisogno di calcolarlo runtime

def soddisfa_specifica_statica_e(W, D, e_s) :
    S_lim = S.limit(s,0)

    e_w = sy.laplace_transform(W, t, s)[0]*s*S_lim
    e_d = sy.laplace_transform(D, t, s)[0]*s*S_lim
    assert sy.Abs(e_w-e_d) <= e_s, sy.Abs(e_w-e_d)
    
    # risposta ad una rampa
    e_w = laplace_transform(W*t, t, s)*s*S_lim
    e_d = laplace_transform(D*t, t, s)*s*S_lim
    assert (e_w-e_d).abs <= e_s

    # risposta ad una parabola
    e_w = laplace_transform(W*(t**2), t, s)*s*S_lim
    e_d = laplace_transform(D*(t**2), t, s)*s*S_lim
    assert (e_w-e_d).abs <= e_s


W = 3.5
D = 2.5
e_s = 0.01
u = 10 # esempio
g = 0
L = u/(s**g) # esempio
S = 1/(1+L) # esempio

soddisfa_specifica_statica_e(W, D, e_s)
