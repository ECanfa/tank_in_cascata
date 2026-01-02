path_to_constants="tank_in_cascata_costanti.m";
run(path_to_constants);
% Punto 4 nel dominio dei tempi

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
S_y_patch = [W*(1.3), W*(1.3), 5, 5];

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
