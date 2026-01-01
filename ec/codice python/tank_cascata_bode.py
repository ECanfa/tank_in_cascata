import scipy as sp
import sympy as sy
from sympy.physics.control.lti import StateSpace
import matplotlib.pyplot as plt
from sympy.physics.control.lti import TransferFunction
from sympy.physics.control.control_plots import bode_plot, step_response_plot
import matplotlib.patches as patch


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

x1, x2, u = sy.symbols('x1 x2 u')
s = sy.symbols('s',complex=True)
t = sy.symbols('t')
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
I = sy.eye(2)
H  = C_eq*(s*I-A_eq).inv()*B_eq + D_eq
(num, den) = H[0].as_numer_denom()

#ottengo coefficienti della funzione di trasferimento non in forma simbolica
#per poter calcolare la tf con scipy per usare signal.bode()

num_coeffs = sy.Poly(num, s).all_coeffs()
den_coeffs = sy.Poly(den, s).all_coeffs()


num_coeffs = [float(c) for c in num_coeffs]
den_coeffs = [float(c) for c in den_coeffs]

tf = sp.signal.TransferFunction(num_coeffs, den_coeffs)

#poles = tf.poles()

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
    e_w = sy.laplace_transform(W*t, t, s)[0]*s*S_lim
    e_d = sy.laplace_transform(D*t, t, s)[0]*s*S_lim
    assert (e_w-e_d).abs <= e_s

    # risposta ad una parabola
    e_w = sy.laplace_transform(W*(t**2), t, s)[0]*s*S_lim
    e_d = sy.laplace_transform(D*(t**2), t, s)[0]*s*S_lim
    assert (e_w-e_d).abs <= e_s


W = 3.5
D = 2.5
e_s = 0.01
u = 10 # esempio
g = 0
L = u/(s**g) # esempio
S = 1/(1+L) # esempio

#soddisfa_specifica_statica_e(W, D, e_s)
print(tf)
#ottengo pulsazione, modulo e fase dalla funzione bode()
w, modulo, fase = sp.signal.bode(tf)

#creo subplot 
fig, ax=plt.subplots(2, 1, layout='constrained')
ax[0].semilogx(w, modulo)   # Bode magnitude plot
ax[0].set_title("|G(jw)|dB")
ax[1].semilogx(w, fase)  # Bode phase plot
ax[1].set_title("arg(G(jw))")


#creazione patch rettangolare di esempio
rectangle = patch.Rectangle((-10, -10), 10, 30,edgecolor = 'red',facecolor='orange')
ax[0].add_patch(rectangle)

plt.show()

