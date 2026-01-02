
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Test del sistema linearizzato nel dominio del tempo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clear; clc;

k1=1;
k2=0.30;
k3=0.45;
k4=0.50;

xe=[9.45, 4.20];
ue=(k1/k4)*sqrt(xe(1));

%Condizione iniziale temporanea
x0 = [0, 0];

%Matrici del sistema linearizzato

A=[-k1/(2*sqrt(xe(1))), 0; k2/(2*sqrt(xe(1))), -k3/(2*sqrt(xe(2)))];
B=[k4; 0];
C=[0, 1];
D=0;

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