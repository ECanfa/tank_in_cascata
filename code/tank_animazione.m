close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run(path_to_constants);

x0 = [0,0];

%animazione sistema
figure(1);
%definizioni valori del grafico 
axis([-10 10  0 50])
%tempo simulazione
t_s = 0:0.1:40; 

%definizione autovalori matrice di stato in anello chiuso k

eigs_feed = [-0.3 -0.4]; %autovalori a parte reale negativa per far si che il sistema converga
K = place(A, B,eigs_feed); %matrice di stato in anello chiuso

%ingresso aggiuntivo di controllo (u(t) = Kx(t) + v(t))

inp = @(x) ue - K*(x-xe');

%risoluzione equazione differenziale
dyn = @(t, x) [-k1*sqrt(x(1))+k4*inp(x); k2*sqrt(x(1))-k3*sqrt(x(2))];

[time, traj] = ode45(dyn, t_s, x0);

y = traj(:,2); %prendiamo x2
x1 = traj(:,1); %analizziamo l'altezza della vasca 1 solo per completezza
%definizione patch per la vasca
x_patch_tank = [-4 4 4 -4];
y_patch_tank_a = [0 0 8 8];
y_patch_tank_b = [12 12 30 30];


grid on;
hold on;
for tt=1:1:length(t_s)
    %aggiornamento grafico
    figure(1);
    clf;

    %definizione dei valori degli assi (x tra -10 e 10 e y 0 50)
    axis([-10 10  0 50]);
    patch(x_patch_tank ,y_patch_tank_b,'y'); %tank 1
    patch(x_patch_tank ,y_patch_tank_a,'y'); %tank 2
    patch(x_patch_tank, [0,0, real(y(tt)), real(y(tt))] ,'b'); %livello dell'acqua tank 2
    patch(x_patch_tank, [12,12, 12+real(x1(tt)), 12+real(x1(tt))] ,'b'); %livello dell'acqua tank 1
    title('Risposta del sistema')
    
    pause(0.0001);
    
end