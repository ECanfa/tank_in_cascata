
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






% =========INIZIO PARTE ANIMAZIONE====
% Bounding Box, uso come riferimento 'assoluto' per le posizioni

% help function
% Definizione Rettangoli, Oggetti della scena
bb = Rectangle(-10, 0, 10, 50); % bounding box
%axis([bb.x bb.w bb.y bb.h]); 
ylim([bb.y bb.h]);
xlim([bb.x bb.w]);
tanks_bb_r = Rectangle((bb.w+bb.x)/2, bb.h/2+bb.y - bb.h/4, bb.w/2, bb.h/2);
reserv_r = Rectangle(tanks_bb_r.x-tanks_bb_r.w, bb.y, bb.w, tanks_bb_r.y);
pompa_bb_r = Rectangle(reserv_r.x, tanks_bb_r.y+tanks_bb_r.h, 5, 10);

% rect delle vasche
tank_1_r = Rectangle(tanks_bb_r.x, tanks_bb_r.h/2+tanks_bb_r.y, ...
                        tanks_bb_r.w, tanks_bb_r.h/2);
tank_2_r = Rectangle(tanks_bb_r.x, tanks_bb_r.y, ...
                         tanks_bb_r.w, tanks_bb_r.h/2);
% rect dell' acqua
tank_1_water_r = Rectangle(tank_1_r.x, tank_1_r.y, tank_1_r.w, 0);
tank_2_water_r = Rectangle(tank_2_r.x, tank_2_r.y, tank_2_r.w, 0);

%definizione patch per la vasca
x_patch_tank =   [-4 4 4 -4];
y_patch_tank_a = [0 0 8 8];
y_patch_tank_b = [12 12 30 30];

% patch per bounding box
tanks_bb_r.patch('r');
reserv_r.patch('g');
% disegno pompa

ax = gca;
h = hgtransform(ax);

%pompa_bb_r.patch('r');

tank_1_r.patch('y'); % salvo due patch per updates 
tank_2_r.patch('y');

p = tank_1_water_r.patch('b');
pp = tank_2_water_r.patch('b');

 pompa_x = [pompa_bb_r.x,                  pompa_bb_r.x,                pompa_bb_r.x+pompa_bb_r.w/4, pompa_bb_r.x+pompa_bb_r.w,     pompa_bb_r.x+pompa_bb_r.w,  pompa_bb_r.x+pompa_bb_r.w/4];
 pompa_y = [pompa_bb_r.y+pompa_bb_r.h/3, pompa_bb_r.y+2*pompa_bb_r.h/3, pompa_bb_r.y+pompa_bb_r.h,   pompa_bb_r.y+2*pompa_bb_r.h/3, pompa_bb_r.y+pompa_bb_r.h/3, pompa_bb_r.y];
pompa_patch = patch(pompa_x,pompa_y,'r');
pompa_patch.Parent = h;

 for tt=1:1:length(t_s)
    
    p.Vertices(3:4,2) = tank_1_water_r.y +real(x1(tt));
    pp.Vertices(3:4,2) = tank_2_water_r.y+real(y(tt));
    drawnow;
    pause(0.01);
end

function b = Rectangle(x,y,w,h)
   b.x = x;
   b.y = y;
   b.w = w;
   b.h = h;
   b.patch = @(color) patch([b.x, b.x+b.w,b.x+b.w,b.x], ...
                       [b.y,b.y,b.y+b.h,b.y+b.h], ...
                        color);
end