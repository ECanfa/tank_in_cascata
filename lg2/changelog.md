# CHANGELOG :

# 12/26
## Da Controllare (Parte 7, slide 14)
Sulle slide parla di specifica per fisica realizzabilita, pendenza k\_L <= k\_L dB/decade per omega elevate,
La pendenza dovrebbe essere -40db essendoci due poli reali

# 12/28
## Regolatore Dinamico
cambiato Regolatore statico = mu = 1/|L(jwc\_min)|, 
Mi e sembrato fosse il caso B, aggiunto una Rete Anticipatrice. T e aT ricavati tramite formule di inversione.
phi\_star = 45 gradi; 
M\_star = 1/cos(phi\_star) + 0.1 (per rientrare nelle specifiche)
visto che M\_star non dovrebbe importare troppo visto che wc rientra nell'intervallo, penso almeno; 

Ho caricato un jpg del diagramma di bode. dovrebbe soddisfare i requisiti

### Test Anello Chiuso punto 4 
Ho provato ad usare il regolatore per il punto 4:

(x) La risposta al gradino w(s) presenta una S% > S\_star% 

(x) La Y(s) con D(s)S(s) e anche con (N(s)F(s)) ha nelle frequenze delle sinusoidi una |Y(s)|dB >>0, problema? 
 potrebbe NON esserlo visto che parla di attenuazione quindi chiede solo che |L(s)|dB = |Y(s)|dB/|N(s)|dB <= An
