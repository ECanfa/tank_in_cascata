close all; clear all; clc;
%Definizioni costanti e punti di equilibrio

k1=1;
k2=0.30;
k3=0.45;
k4=0.50;

xe=[9.45, 4.20];
ue=(k1/k4)*sqrt(xe(1));

%Matrici del sistema linearizzato

A=[-k1/(2*sqrt(xe(1))), 0; k2/(2*sqrt(xe(1))), -k3/(2*sqrt(xe(2)))];
B=[k4; 0];
C=[0, 1];
D=0;

%Definizione spazio degli stati

modello = ss(A,B,C,D);

%Simulazione del sistema ad un gradino unitario

tt = 0:0.1:10; 
uu = ones ( length ( tt ) , 1) ; 
[Y , TT , X ] = lsim ( modello , uu , tt , xe ) ;
plot ( TT , X ) ;
title('Simulazione del sistema ad un gradino unitario');

%Calcolo della funzione di trasferimento

G = tf(modello);

%Risposta della funzione di trasferimento in anello aperto ad un gradino

YY = step(G,tt);
figure;
plot(tt, YY);
title('Risposta della funzione di trasferimento ad un gradino');
hold on; grid on; zoom on;

%Diagramma di bode della funzione di trasferimento in anello aperto G

figure;
bode(G);
title('Diagramma di bode della funzione di trasferimento in anello aperto');
hold on; grid on; zoom on;

%Calcolo margine di ampiezza, fase , pulsazione critica e omega pi

[M_a, M_f, omega_pi, omega_c] = margin(G);
fprintf('La pulsazione critica di G è %.1f rad/s.\n',omega_c);
fprintf('Il margine di fase di G è %.1f gradi.\n',M_f);
