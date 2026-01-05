Progetto Tank in cascata

Nel progetto è presente uno script chiamato tank_in_cascata_costanti.m dove vengono definite le costanti, la funzione di trasferimento e le funzioni di sensitività, usato per rendere il codice più leggibile. Affinché gli script vengano eseguiti con successo è necessario che la directory di esecuzione dello script sia la stessa di "tank_in_cascata_costanti.m".

Gli script da eseguire sono: 
- tank_in_cascata_costanti, dove si trovano le costanti del progetto, la funzione di trasferimento, il progetto del regolatore e le funzioni di sensitività.
- tank_in_cascata_specifiche, dove si mostra il diagramma di bode della funzione di anello con le patch relative alle specifiche del progetto
- tank_test_disturbo_dominio_tempo, in cui abbiamo svolto il punto 4, ovvero la risposta del sistema linearizzato al riferimento w(t) e ai disturbi n(t) e d(t)
- tank_test_disturbo_dominiio_complesso è una simulazione che abbiamo fatto per vedere l'andamento della risposta nel dominio frequenziale, nonché l'attenuazione dei disturbi (in quando le specifiche di attenuazione erano riportate in dB).
-simulazione_sistema_non_lineare.slx in cui è presente lo schema a blocchi del sistema non lineare
-simulazione_sistema_non_lineare_code, che contiene lo svolgimento dei punti 5.2 e 5.3
-tank_animazione, che contiene l'animazione del sistema retroazionato con la matrice di stato in anello chiuso K opportunamente progettata
-animazione_regolatore, che contiene l'animazione del sistema linearizzato in presenza del regolatore con relativo grafico dell'andamento nel tempo.
