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
title('Diagramma di bode della funzione di trasferimento');
hold on; grid on; zoom on;

%Calcolo margine di ampiezza, fase , pulsazione critica e omega pi

[M_a, M_f, omega_pi, omega_c] = margin(G);
fprintf('La pulsazione critica di G è %.1f rad/s.\n',omega_c);
fprintf('Il margine di fase di G è %.1f gradi.\n',M_f);

%Definizioni dei limiti del grafico
omega_plot_min = 1e-5;
omega_plot_max = 1e7;

%Attenuazione disturbo in uscita
%Specifiche di attenuazione del disturbo in uscita e rumore di misura
omega_d_min = 1e-5; %approssimazione verso 0
omega_d_max = 4.0;
A_d = 40;

omega_n_min = 1e5;
omega_n_max = 5e6;
A_n = 63;

%Creazione patch
figure;
hold on;

s = tf('s');

%Patch tempo di assestamento

p = 1/s;
patch_x_e = [omega_plot_min; omega_d_max; omega_d_max; omega_plot_min];
val_p = 20*log(abs(evalfr(p, omega_d_max)));
patch_y_e = [20*log(abs(evalfr(p, omega_plot_min))); val_p; val_p ; val_p];
patch(patch_x_e, patch_y_e,'r','FaceAlpha',0.2,'EdgeAlpha',0);

%Patch per il disturbo in uscita
patch_x_d = [omega_d_min; omega_d_max; omega_d_max; omega_d_min];
patch_y_d = [A_d; A_d; -350; -350];
patch(patch_x_d, patch_y_d,'r','FaceAlpha',0.2,'EdgeAlpha',0);

%Patch per rumore di misurazione
patch_x_n = [omega_n_min; omega_n_max; omega_n_max; omega_n_min];
patch_y_n = [-A_n; -A_n; 150; 150];
patch(patch_x_n, patch_y_n,'r','FaceAlpha',0.2,'EdgeAlpha',0);

%Specifiche dinamiche

S_star = 30;
T_a_5_star = 0.050;
xi_star  = abs(log(S_star/100))/(sqrt(pi^2 + log(S_star/100)^2));
M_f_min = 100*xi_star;

omega_c_min = 300/(M_f_min*T_a_5_star);%-log(0.05)/T_a_5_star

%Specifica tempo di assestamento

patch_Ta_x = [omega_plot_min; omega_c_min; omega_c_min; omega_plot_min];
patch_Ta_y = [0; 0; -350; -350];
patch(patch_Ta_x, patch_Ta_y,'b','FaceAlpha',0.2,'EdgeAlpha',0);



omega_c_max = omega_n_min;

% ====================
 % SINTESI CONTROLLORE PROVA
% ====================
% (luci) NOTA metto qui per il momento

%Parte da controllare guadagno statico mu
W_star = 3.5;
D_star = 2.5;
e_star = 0.01;

% per Teorema Valore Finale
%
% ====== Sintesi Regolatore Statico ======
% 
mu_err = (W_star+D_star)/e_star - 1;
mu_min_dist = 10^(A_d/20); %mu_min_dist = 10^(A_d/20);

G_0 = abs(evalfr(G, 0));


omega_c_star = omega_c_min;%+ (omega_c_max - omega_c_min)/4;
mu_omega_c_star = 1/abs(evalfr(G,omega_c_star));
mu_R = max(mu_err/G_0, mu_omega_c_star/G_0);

R_s = mu_R;
G_esteso = R_s*G;

% Criterio Fisica Realizzabilita da guardare
kG = -40; %grado relativo di G(s) 2, dunque -40dB/decade
patch_fis_x = [omega_n_min;omega_plot_max;omega_plot_max;omega_n_min];
y_ = 20*log10(abs(evalfr(G,omega_n_min)));
y__ = 20*log10(abs(evalfr(G,omega_plot_max)));

patch_fis_y = [0;0;y__-y_;0];
patch(patch_fis_x,patch_fis_y,'r','FaceAlpha',0.2,'EdgeAlpha',0);

% =========================== 
% Sintesi Regolatore Dinamico
% ===========================
% Caso B
%Formule di inversione

phi_star = pi/3;
cos_phi_star = cos(phi_star);
sin_phi_star = sin(phi_star);
M_star = 1/(cos(phi_star))+0.1;

% controllo parametri scelti, formule di inversione
if (M_star < 0) ...
    || (0 > phi_star || pi/2 < phi_star) ...
    || (cos_phi_star < 1/M_star)
    fprintf('[ERRORE]: parametri della rete anticipatrice.\n');
end

T_zero_Rd = (M_star - cos_phi_star)/(omega_c_star*sin_phi_star);
T_polo_Rd = (cos(phi_star) - 1/M_star)/(omega_c_star*sin_phi_star);
fprintf('T: %.6f\n', T_zero_Rd);
fprintf('aT: %.6f\n', T_polo_Rd);

R_d = 1*(1+T_zero_Rd*s)/(1+T_polo_Rd*s);

RR = R_s*R_d;

U = [0, 1];

L=RR*G;
fprintf('mu di L(s)%.1f.\n',abs(evalfr(L, 0)));
[M_a, M_f, omega_pi, omega_c] = margin(L);
fprintf('La pulsazione critica di L è %.1f rad/s.\n',omega_c);
fprintf('Il margine di fase di L è %.1f gradi.\n',M_f);

%Diagramma di Bode della L(s) temporanea
margin(G_esteso,{omega_plot_min,omega_plot_max});
hold on;
margin(L,{omega_plot_min,omega_plot_max});

%Specifica sovraelongazione(Margine di fase)
patch_Mf_x = [omega_c_min; omega_c_max; omega_c_max; omega_c_min];
patch_Mf_y = [M_f_min - 180; M_f_min - 180; -270; -270];
patch(patch_Mf_x, patch_Mf_y,'g','FaceAlpha',0.2,'EdgeAlpha',0);

grid on; zoom on;

% Spefiche di robustezza
M_f_robusto = max(30, M_f_min);
if M_f < M_f_robusto
    fprintf('[ERRORE]: Il margine di fase non rispetta le caratteristiche\n')
end