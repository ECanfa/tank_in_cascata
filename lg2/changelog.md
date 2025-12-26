# CHANGELOG :

# 12/26
## Calcolato mu minimo per e <= e\_star
con del Teorema del valore finale mi esce
     e\_inf\_w = lim\_s->0 sL[w-y] = s(W/s - F(s)W) = W(1 - L(s)/1+L(s)) = W/1+mu
     e\_inf\_d = lim\_s->0 sL[w-y] = s(D/s - F(s)D) = D(1 - L(s)/1+L(s)) = D/1+mu
    mu = (W+D)/e\_star - 1

Nell'esempio del lab -1 non c'e, probabilmente ho sbagliato qualche passaggio ma non volevo copiare senza capire

## Cambiato il guadagno della R\_s statica:
con il guadagno statico di sopra L(s) rientrava nella zona proibita per specifiche attenuazione disturbo,
in piu  w\_c non era nel range [w\_min,w\_max]; Ho caricato degli screenshot per comodita

Per fare delle prove ho messo il guadagno = 1/|G(jw\_max)| cosi che w\_c coincidesse con w\_max

## Da Controllare (Parte 7, slide 14)
Sulle slide parla di specifica per fisica realizzabilita, pendenza k\_L <= k\_L dB/decade per omega elevate,
La pendenza dovrebbe essere -40db essendoci due poli reali
