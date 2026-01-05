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
%%
load_system("simulazione_punto_4");
mdl = "simulazione_punto_4";

simIn = Simulink.SimulationInput(mdl);
% Setting dei Parametri

% blk = mdl+"/tf_RR";
% simIn = setBlockParameter(simIn, blk, "Numerator", "["+ ...
%     num2str(RR.Numerator{1}) + "]");
% 
% blk = mdl+"/tf_RR";
% simIn = setBlockParameter(simIn, blk, "Denominator", "["+ ...
%     num2str(RR.Denominator{1}) + "]");

simIn = setModelParameter(simIn(i),"Solver","ode45",...
    "StopTime","20");

blk = mdl+"/Disturbo_Gen";
simIn = setBlockParameter(simIn, blk, "Frequency", "["+ ...
    num2str(D_F) + "]");

blk = mdl+"/Disturbo_Gen";
simIn = setBlockParameter(simIn, blk, "Frequency", "["+ ...
    num2str(D_F) + "]");
simIn = setBlockParameter(simIn, blk, "Amplitude", "["+ ...
    num2str(D_A) + "]");
blk = mdl+"/Misura_Gen";
simIn = setBlockParameter(simIn, blk, "Frequency", "["+ ...
    num2str(N_F) + "]");
simIn = setBlockParameter(simIn, blk, "Amplitude", "["+ ...
    num2str(N_A) + "]");

Simulink.sdi.clear;
out = sim(simIn,"UseFastRestart","on");
runIDs = Simulink.sdi.getAllRunIDs;

figure; hold on; grid on;

for i = 1:length(runIDs)
    run = Simulink.sdi.getRun(runIDs(i));
    outSignal = getSignalByIndex(run,1);

    t = outSignal.Values.Time;
    %necessario uso di squeeze su outSignal.Values.Data perchè vettore
    %3D [campione, singleton, valori]
    y = squeeze(outSignal.Values.Data);
    y = y(:,1);  
    subplot(length(runIDs),1, i);
   
    plot(t,y);
    title("w(t)");
end