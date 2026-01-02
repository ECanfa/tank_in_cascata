close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run(path_to_constants);

% Punto 4 nel dominio dei tempi

% Risposta a w(t) riferimento
W = 3.5;
T_simulation = 2*T_a_5_star;
[y_step,t_step] = step(W*F, T_simulation);
plot(t_step,y_step,'b');
grid on, zoom on, hold on;

%teorema del valore finale
% W/s*F*s=WF => LV;
LV = evalfr(W*F,0);

% vincolo sovraelongazione
patch([0,T_simulation,T_simulation,0],[LV*(1+S_star/100),LV*(1+S_star/100),LV*2,LV*2],'r','FaceAlpha',0.3,'EdgeAlpha',0.5);

% vincolo tempo di assestamento al 5%
patch([T_a_5_star,T_simulation,T_simulation,T_a_5_star],[LV*(1-0.05),LV*(1-0.05),0,0],'g','FaceAlpha',0.1,'EdgeAlpha',0.5);
patch([T_a_5_star,T_simulation,T_simulation,T_a_5_star],[LV*(1+0.05),LV*(1+0.05),LV*2,LV*2],'g','FaceAlpha',0.1,'EdgeAlpha',0.1);

ylim([0,LV*2]);

Legend_step = ["Risposta al gradino"; "Vincolo sovraelongazione"; "Vincolo tempo di assestamento"];
legend(Legend_step);

figure(2);

S = 1/(1+L);
% Check Disturbo (Da controllare)
D = 1.5;
tt = 0:1e-2:2e2;
d_t = 0;
for n = 1:4
    omega_d = 0.4*n;
    d_t = d_t + D*sin(omega_d*tt); %trasformata di sin(wt)sca(t) 
end
y_d = lsim(S,d_t,tt);
hold on, grid on, zoom on
plot(tt,d_t,'m');
plot(tt,y_d,'b');
grid on;
legend('d(t)','y_d(t)');

% Check Disturbo di Misura
% (luci)
% Da controllare, pero il fatto che modulo sia cosi negativo ha senso

figure(3);
N = 0.1;
n_t = 0;
for n = 1:4
    omega_n = 2*10^5*n;
    n_t = n_t + N*sin(omega_n*tt); 
end

y_n = lsim(-F,n_t,tt);
hold on, grid on, zoom on
plot(tt,n_t,'m');
plot(tt,y_n,'b');
grid on;
legend('n(t)','y_n(t');