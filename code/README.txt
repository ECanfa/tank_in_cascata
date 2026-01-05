PROGETTO TANK IN CASCATA 

		==========================
		        IMPORTANTE        
		==========================
Cambiare la directory corrente di matlab nella ./code del progetto. I motivi sono spiegati sotto

Per semplicita e per facilitare la lettura, abbiamo creato un unico script di setup per ogni altro script, lo script "tank_in_cascata_constanti.m".


Gli SCRIPT PER PUNTO sono: 
1-2)
- tank_in_cascata_costanti.m
 dove si trovano le costanti del progetto, la funzione di trasferimento, il progetto del regolatore e le funzioni di sensitività.

3)
- tank_in_cascata_specifiche.m
 dove si mostra il diagramma di bode della funzione di anello con le patch relative alle specifiche del progetto

4)
- tank_test_disturbo_dominio_tempo.m e tank_test_disturbo_dominio_complesso.
Dove analizziamo (separatamente) le risposte del sistema linearizzato, agli ingressi w(t), d(t) e n(t). Sia Nel dominio complesso per
l'andamento della risposta nel dominio frequenziale, e per l'attenuazione dei disturbi. Nonche nel dominio del tempo per controllare le specifiche di risposta ad uno scalino.

-simulazione_sistema_lineare_code e simulazione_sistema_lineare_slx
 Progetto Simulink in cui è presente lo schema a blocchi del sistema lineare con ingresso w(t) e i disturbi d(t) e n(t), PER LA SIMULAZIONE della risposta complessiva RUN simulazione_sistema_lineare_code.m

5) 
-simulazione_sistema_non_lineare.slx, simulazione_sistema_non_lineare_code
Per RUN 5.1:
eseguire prima SEZIONE di simulazione_sistema_lineare_code.m per caricare le variabili di workspace, poi eseguire direttamente da Simulink
		==========================
		=       IMPORTANTE       =
		==========================
Abbiamo svolto i punti 5.2,5.3 nella loro interezza. Tuttavia, con i disturbi in forma sinusoidale abbiamo riscontrato tempi di simulazione eccessivamente lunghi per quanto il codice FUNZIONI.
Per questo abbiamo lasciato su Simulink anche i disturbi in formato gradino nel caso voleste dare uno sguardo veloce a grafici e risultati delle simulazioni.


Opzionale) 
-tank_animazione, che contiene l'animazione del sistema retroazionato con la matrice di stato in anello chiuso K opportunamente progettata
-animazione_regolatore, che contiene l'animazione del sistema linearizzato in presenza del regolatore con relativo grafico dell'andamento nel tempo.
