%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Test del sistema linearizzato
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (luci)
% Per il momento non usa l'effettivo sistema ad anello chiuso,
% ho provato a scrivere comunque il codice per portarci avanti
% Nell'esempio del lab per il disturbo usa la S(s) invece della F(s) 
% Ma non vedo perche non dovrebbe andare bene lo stesso.
%
% In piu, sia per d(t) che n(t) plotta la risposta del sistema
% Ho pensato che convenisse provare a mostrare bode della Y
% in modo da poter controllare l'attenuazione


close all; clear; clc;
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

modello = ss(A,B,C,D);

%Definizione spazio degli stati
G = tf(modello);

%Testare sul sistema in anello chiuso
R = 1;
L = R*G;
F = L/(1+L);

% Risposta a w(t) riferimento

W = 3.5;
[y, tOut] = step(W*L, 2);

% Vincolo Tempo di Assestamento
eps = 0.05;
Ta_eps = 0.05;
Ta_x_patch = [0, 2, 2, 0];
Ta_y_patch = [W+W*eps, W+W*eps, W-W*eps, W-W*eps];

grid on; zoom on; hold on;

patch(Ta_x_patch, Ta_y_patch, 'r','FaceAlpha',0.2,'EdgeAlpha',0);

% Vincolo di Sovraelungazione (Da Fare)
S_x_patch = Ta_x_patch;
S_y_patch = [W+W*0.3, W+W*0.3, 4, 4];

patch(S_x_patch, S_y_patch, 'b','FaceAlpha',0.2,'EdgeAlpha',0);

plot(tOut, y);
title('Risposta della funzione ad Anello Chiuso al riferimento w(t)');


% Check Disturbo di Misura (Da controllare)
A_d = 1.5;
s = tf('s');
sin_transform = 0;
for n = 1:4
    omega_d = 0.4*n;
    sin_transform = sin_transform + omega_d/(s^2+omega_d^2); %trasformata di sin(wt)sca(t) 
end
YY = sin_transform*F;

figure(2);
bode(YY);
title('Trasformata della risposta del sistema ad anello chiuso per un disturbo d(t)');

% Check Disturbo di Misura
% (luci)
% Da controllare, pero il fatto che modulo sia cosi negativo ha senso

A_n = 0.1;
sin_transform = 0;
for n = 1:4
    omega_n = 2*10^5*n;
    sin_transform = sin_transform + omega_n/(s^2+omega_n^2); 
end
YY = sin_transform*F;

figure(3);
bode(YY);
title('Trasformata della risposta del sistema ad anello chiuso per un disturbo n(t)');
