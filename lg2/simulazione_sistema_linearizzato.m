%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Test del sistema linearizzato
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% (luci)
% sia per d(t) che n(t) plotta la risposta del sistema
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

% (luci) 12/28 test con nuovo regolatore
S_star = 30;
T_a_5_star = 0.050;
xi_star  = abs(log(S_star/100))/(sqrt(pi^2 + log(S_star/100)^2));
M_f_min = 100*xi_star;

omega_c_min = 300/(M_f_min*T_a_5_star);

omega_c_star = omega_c_min;%+ (omega_c_max - omega_c_min)/4;
mu_omega_c_star = 1/abs(evalfr(G,omega_c_star));
mu_R = max(0, mu_omega_c_star/abs(evalfr(G, 0)));
RR_s = mu_R;

phi_star = pi/4;
cos_phi_star = cos(phi_star);
sin_phi_star = sin(phi_star);
M_star = 1/(cos(phi_star))+0.1;

T_zero_Rd = (M_star - cos_phi_star)/(omega_c_star*sin_phi_star);
T_polo_Rd = (cos(phi_star) - 1/M_star)/(omega_c_star*sin_phi_star);

s = tf('s');
RR_d = 1*(1+T_zero_Rd*s)/(1+T_polo_Rd*s);

L = RR_s*RR_d*G;
F = L/(1+L);

% Risposta a w(t) riferimento

W = 3.5;
[y, tOut] = step(W*F, 2);

% Vincolo Tempo di Assestamento
eps = 0.05;
Ta_eps = 0.05;
Ta_x_patch = [0, 2, 2, 0];
Ta_y_patch = [W+W*eps, W+W*eps, W-W*eps, W-W*eps];

grid on; zoom on; hold on;

patch(Ta_x_patch, Ta_y_patch, 'r','FaceAlpha',0.2,'EdgeAlpha',0);

% Vincolo di Sovraelungazione

S_x_patch = Ta_x_patch;
S_y_patch = [W*(1.3), W*(1.3), 4, 4];

patch(S_x_patch, S_y_patch, 'b','FaceAlpha',0.2,'EdgeAlpha',0);

plot(tOut, y);
title('Risposta della funzione ad Anello Chiuso al riferimento w(t)');

S = 1/(1+L);
% Check Disturbo (Da controllare)
A_d = 1.5;
s = tf('s');
sin_transform = 0;
for n = 1:4
    omega_d = 0.4*n;
    sin_transform = sin_transform + omega_d/(s^2+omega_d^2); %trasformata di sin(wt)sca(t) 
end
YY = sin_transform*S;
figure(2);
omega_d_min = 1e-5; %approssimazione verso 0
omega_d_max = 4.0;
bode(YY,{omega_d_min, omega_d_max});
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
omega_n_min = 1e5;
omega_n_max = 5e6;

figure(3);
bode(YY,{omega_n_min, omega_n_max});
title('Trasformata della risposta del sistema ad anello chiuso per un disturbo n(t)');
