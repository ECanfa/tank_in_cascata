close all; clear; clc;

% Tank in Cascata Costanti di Workspace
k1=1;
k2=0.30;
k3=0.45;
k4=0.50;
xe=[9.45, 4.20];
ue=(k1/k4)*sqrt(xe(1));

% Matrici del sistema linearizzato intorno (xe,ue)
A=[-k1/(2*sqrt(xe(1))), 0; k2/(2*sqrt(xe(1))), -k3/(2*sqrt(xe(2)))];
B=[k4; 0];
C=[0, 1];
D=0;

% Funzione di trasferimento del sistema linearizzato
modello = ss(A,B,C,D);
G = tf(modello);

%Calcolo margine di ampiezza, fase , pulsazione critica e omega pi
[M_a, M_f, omega_pi, omega_c] = margin(G);

%Definizioni dei limiti del grafico
omega_plot_min = 1e-5;
omega_plot_max = 1e7;

% Specifiche di progettazione del Regolatore

%Specifiche di attenuazione del disturbo in uscita e rumore di misura
omega_d_min = 1e-5; %approssimazione verso 0
omega_d_max = 4.0;
A_d = 40;
omega_n_min = 1e5;
omega_n_max = 5e6;
A_n = 63;

%Specifiche dinamiche
S_star = 30;
T_a_5_star = 0.050;
xi_star  = abs(log(S_star/100))/(sqrt(pi^2 + log(S_star/100)^2));
M_f_min = 100*xi_star;

% Intervallo omega
omega_c_min = 300/(M_f_min*T_a_5_star);
omega_c_max = omega_n_min;

% Regolatore
s = tf('s');

% Sintesi Regolatore Statico

% Specifiche Errore a Regime
W_star = 3.5; D_star = 2.5; e_star = 0.01;

mu_err = (W_star+D_star)/e_star - 1; % per Teorema Valore Finale
mu_min_dist = 10^(A_d/20);

G_0 = abs(evalfr(G,0));
omega_c_star = omega_c_min;
mu_omega_c_star = 1/abs(evalfr(G,omega_c_star));

mu_R = mu_omega_c_star/G_0;
RR_s = mu_R;
G_esteso = RR_s*G;

% Sintesi Regolatore Dinamico

% Rete anticipatrice - uso Formule di Inversione
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

RR_d = 1*(1+T_zero_Rd*s)/(1+T_polo_Rd*s);


RR=RR_s*RR_d;

% Sistema Anello Aperto, Anello Chiuso, Funzione Di Sensitivita
L=RR*G;
S=1/(1+L);
F=L/(1+L);
Q=RR/(1+L);