import numpy as np
import sympy as sy
import scipy as sp
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from sympy.physics.control.lti import TransferFunction

fig, ax = plt.subplots(2, 1, layout='constrained')
x = range(-100,100)
for row in 0,1:
    ax[row].plot(x, x)

    ax[row].set_xscale("log")
    ax[row].set_yscale("log")
    ax[row].set_xlabel("w")
    xticks = [10**i for i in range(-2,3)]
    ax[row].set_xticks(xticks,minor=True)

ax[0].set_title("|L(jw)|dB")
ax[1].set_title("arg(L(jw))")

plt.show()
