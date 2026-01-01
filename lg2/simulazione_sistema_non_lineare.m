echo off; close all; clear; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULINK TEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Variabili Globali %
% Runnare questo prima di aprire simulazione_sistema_non_lineare.slx


k1=1;
k2=0.30;
k3=0.45;
k4=0.50;

xe = [9.45, 4.20];
ue = (k1/k4)*sqrt(xe(1));
x0 = [xe(1), xe(2)];
U  = [0 1];

A=[-k1/(2*sqrt(xe(1))), 0; k2/(2*sqrt(xe(1))), -k3/(2*sqrt(xe(2)))];
B=[k4; 0];
C=[0, 1];
D=0;

%Definizione spazio degli stati

modello = ss(A,B,C,D);

%Calcolo della funzione di trasferimento

G = tf(modello);

% Regolatore
% variabili

%Definizioni dei limiti del grafico
omega_plot_min = 1e-5;
omega_plot_max = 1e7;

%Attenuazione disturbo in uscita
%Specifiche di attenuazione del disturbo in uscita e rumore di misura
omega_d_min = 1e-5; %approssimazione verso 0
omega_d_max = 4.0;

omega_n_min = 1e5;
omega_n_max = 5e6;

%Specifiche dinamiche
S_star = 30;
T_a_5_star = 0.050;
xi_star  = abs(log(S_star/100))/(sqrt(pi^2 + log(S_star/100)^2));
M_f_min = 100*xi_star;

omega_c_min = 300/(M_f_min*T_a_5_star);

G_0 = abs(evalfr(G,0));
omega_c_star = omega_c_min;%+ (omega_c_max - omega_c_min)/4;
mu_omega_c_star = 1/abs(evalfr(G,omega_c_star));
mu_R = mu_omega_c_star/G_0;
RR_s = mu_R;
%Formule di inversione

phi_star = pi/4;
cos_phi_star = cos(phi_star);
sin_phi_star = sin(phi_star);
M_star = 1/(cos(phi_star))+0.1;


T_zero_Rd = (M_star - cos_phi_star)/(omega_c_star*sin_phi_star);
T_polo_Rd = (cos(phi_star) - 1/M_star)/(omega_c_star*sin_phi_star);
fprintf('T: %.6f\n', T_zero_Rd);
fprintf('aT: %.6f\n', T_polo_Rd);

s = tf('s');
RR_d = 1*(1+T_zero_Rd*s)/(1+T_polo_Rd*s);


RR=RR_s*RR_d;

% Disturbi
% per il momento costanti, e assunto scalino
D = 0;
N = 0;
W = 1;

start_simulink();

open_system("lg2/simulazione_sistema_non_lineare");
mdl = "simulazione_sistema_non_lineare";

simIn = Simulink.SimulationInput(mdl);
simIn = setModelParameter(simIn,"Solver","ode45",...
    "StopTime","20");

% TODO
% Randomize Values for inputs


% TODO
% Set Blocks 
blk = strcat(mdl,"/Constant2");
simIn = setBlockParameter(simIn,blk,"Value","6.1482");

% TODO
% simulate systems, parsim() needed
out = sim(simIn);

% TODO
% Fix the graph that comes out
%figure; 
plot(out.yout, 'r');
bdclose();
