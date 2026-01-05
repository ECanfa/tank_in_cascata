close all; clear; clc;


path_to_constants="tank_in_cascata_costanti.m";
run("tank_in_cascata_costanti.m");

% simulazione punto 4 in matlab
W = 1;
% Valori del disturbo
D_F = zeros(1,4);
D_A(1:4) = 1.5;
d_w = .4;

for i=1:length(D_F)
    D_F(i) = d_w*i;
end

N_F = zeros(1,4);
N_A(1:4) = 0.1;
n_w = 2e5;

for i=1:length(N_F)
    N_F(i) = n_w*i;
end
