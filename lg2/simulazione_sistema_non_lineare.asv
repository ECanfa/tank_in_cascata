echo off; close all; clear; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMULINK TEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Risolvere il sistema non lineare

k1=1;
k2=0.30;
k3=0.45;
k4=0.50;

xe=[9.45, 4.20];
ue=(k1/k4)*sqrt(xe(1));

% uso anonymous functions 
u = @(t) ue; % NOTA solo per prova
dxdt = @(t,x) [ -k1*sqrt(x(1)) + k4*sqrt(u(t)); k2*sqrt(x(1)) - k3*sqrt(x(2)) ];

% calcolare la x e la y
% ye ricavata dal grafico
tspan = linspace(0, 1000, 10);
x0 = [xe(1);xe(2)];
[tt, x] = ode45(dxdt, tspan, x0)
plot(tt, x);
legend('x1', 'x2');
ylabel('altezza');
figure(2);
y = x(:, 2);
plot(tt, y); % per il momento supponiamo prenda l'intero stato
legend('output');
ylabel('altezza');
