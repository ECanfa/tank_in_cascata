import math
import scipy as sp
import numpy as np

# TODO 
# Add suppress warning for transfer function

#======================================
#             CONSTANTS
#======================================

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

f  = np.round( np.array([[-k1*(ae[0]**0.5) + k4*ue],
               [ k2*(ae[0]**0.5) - k3*(ae[1]**0.5)]]), 2)

assert np.equal(f, np.zeros(np.shape([2, 1]))).all()


#======================================
#             LINEARIZATION
#======================================

A= np.array([[-k1/2*(ae[0]**-0.5),           0          ],
            [  k2/2*(ae[0]**-0.5), -k3/2*(ae[1]**-0.5)]])

B= np.array([[k4],
            [0]])


C= np.array([0, 1])

D= np.array(0)

ss = sp.signal.StateSpace(A, B, C, D)

#======================================
#           TRANSFER FUNCTION
#======================================
tf = sp.signal.TransferFunction(ss)

#print(tf)
print(tf.num)
print(tf.den)
