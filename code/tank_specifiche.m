close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run("tank_in_cascata_costanti.m");

% Punto 2

%Simulazione del sistema ad un gradino unitario

tt = 0:0.1:10; 
uu = ones ( length ( tt ) , 1) ; 
[Y , TT , X ] = lsim ( modello , uu , tt , xe ) ;
plot ( TT , X ) ;
title('Simulazione del sistema ad un gradino unitario');

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


figure; hold on; grid on; zoom on;
%Patch tempo di assestamento
patch_Ta_x = [omega_plot_min; omega_c_min; omega_c_min; omega_plot_min];
patch_Ta_y = [0; 0; -350; -350];
patch(patch_Ta_x, patch_Ta_y,'b','FaceAlpha',0.2,'EdgeAlpha',0);


%Patch per il disturbo in uscita
patch_x_d = [omega_d_min; omega_d_max; omega_d_max; omega_d_min];
patch_y_d = [A_d; A_d; -350; -350];
patch(patch_x_d, patch_y_d,'r','FaceAlpha',0.2,'EdgeAlpha',0);

%Patch per rumore di misurazione
patch_x_n = [omega_n_min; omega_n_max; omega_n_max; omega_n_min];
patch_y_n = [-A_n; -A_n; 150; 150];
patch(patch_x_n, patch_y_n,'r','FaceAlpha',0.2,'EdgeAlpha',0);

% Criterio Fisica Realizzabilita da guardare
kG = -40; %grado relativo di G(s) 2, dunque -40dB/decade
patch_fis_x = [omega_n_min;omega_plot_max;omega_plot_max;omega_n_min];
y_ = 20*log10(abs(evalfr(G,omega_n_min)));
y__ = 20*log10(abs(evalfr(G,omega_plot_max)));

patch_fis_y = [0;0;y__-y_;0];
patch(patch_fis_x,patch_fis_y,'r','FaceAlpha',0.2,'EdgeAlpha',0);

% Grafico della funzione ad anello aperto
[M_a, M_f, omega_pi, omega_c] = margin(L);

%Diagramma di Bode della L(s) temporanea
%margin(G_esteso,{omega_plot_min,omega_plot_max});
%hold on;
margin(L,{omega_plot_min,omega_plot_max});

%Specifica sovraelongazione(Margine di fase)
patch_Mf_x = [omega_c_min; omega_c_max; omega_c_max; omega_c_min];
patch_Mf_y = [M_f_min - 180; M_f_min - 180; -270; -270];
patch(patch_Mf_x, patch_Mf_y,'g','FaceAlpha',0.2,'EdgeAlpha',0);
