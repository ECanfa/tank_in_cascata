close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run(path_to_constants);
% Punto 4 nel dominio delle frequenze

% Risposta a w(s) riferimento
W = 3.5;
bode(W/s*F,{omega_d_min, omega_d_max});
title('Risposta del sistema in Anello Chiuso al riferimento W(s)');

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
hold on;
bode(sin_transform,{omega_d_min, omega_d_max});
title('Trasformata della risposta del sistema in anello chiuso per un disturbo D(s)');
legend('Y_d(s)','D(s)');

% Check Disturbo di Misura

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
hold on;
bode(sin_transform,{omega_n_min, omega_n_max})
title('Trasformata della risposta del sistema in anello chiuso per un disturbo N(s)');
legend('Y_n(s)','N(s)');