close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run(path_to_constants);

W = 3.5;
T_simulation = 2*T_a_5_star;
[y_step,t_step] = step(W*F, T_simulation);

figure(1);
%definizioni valori del grafico 
axis([-10 10  0 50])

min_T = 0;
max_T = t_step(end);
min_Y = 0;
max_Y = max(y_step)*1.1;

%definizione patch per la vasca
x_patch_tank = [-4 4 4 -4];
y_patch_tank_a = [0 0 8 8];


for tt=1:2:length(t_step)
    figure(1);
    clf;

    subplot(2,1,1);
    plot(t_step(1:tt), y_step(1:tt), 'b', 'LineWidth', 1.5);
    axis([min_T max_T min_Y max_Y]);
    grid on; box on;
    title(['Risposta al gradino 3.5·1(t) — t = ',num2str(t_step(tt),'%.2f'),' s']);

    %definizione dei valori degli assi (x tra -10 e 10 e y 0 12)
    subplot(2,1,2);
    axis([-10 10  0 12]);
    patch(x_patch_tank ,y_patch_tank_a,'y'); %tank 2
    hold on;
    patch(x_patch_tank, [0,0, real(y_step(tt)), real(y_step(tt))] ,'b'); %livello dell'acqua tank 2
    title('Risposta del sistema')
    
    pause(0.0001);
    
end