close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run("tank_in_cascata_costanti.m");

% Disturbi
% per il momento costanti, e assunto scalino
D = 0;
N = 0;
W = 1;
U = [0 1];
%% 
% Supponendo un riferimento w(t) = 1(t), esplorare il range di condizioni iniziali dello stato del sistema
% non lineare (nell'intorno del punto di equilibrio) tali per cui l'uscita del sistema in anello chiuso converga
% a h(xe, ue).

Simulink.sdi.clear;
W = 1;

x1_max_noise = xe(1); % range di valori randomizzati di prova [0, 2xe[
x2_max_noise = xe(2);
r = rand([1,5]);
x1(1:length(r)) = xe(1) + (-x1_max_noise  + 2*r*x1_max_noise);
x2(1:length(r)) = xe(2) + (-x2_max_noise + 2*r*x2_max_noise);


load_system("simulazione_sistema_non_lineare");
mdl = "simulazione_sistema_non_lineare";

simIn(1:length(r)) = Simulink.SimulationInput(mdl);

for i = length(r):-1:1
    simIn(i) = setModelParameter(simIn(i),"Solver","ode45",...
    "StopTime","20");
    blk = strcat(mdl,"/Constant1");
    simIn(i) = setBlockParameter(simIn(i),blk,"Value","["+x1(1,i)+" "+x2(1,i)+ "]");
end

%out = parsim(simIn, TransferBaseWorkspaceVariables="on");
out = sim(simIn,"UseFastRestart","on");


% retrieve outputs from simulations runs
runIDs = Simulink.sdi.getAllRunIDs;
for i = length(r):-1:1
    run = Simulink.sdi.getRun(runIDs(i));
    outSignal = getSignalByIndex(run,1);
    plotOnSubPlot(outSignal,1,1,true)
end
Simulink.sdi.view;

bdclose();

%% 
% Esplorare il range di ampiezza di riferimenti a gradino tali per cui il controllore rimane efficace sul
% sistema non lineare.

Simulink.sdi.clear;

w_max_step = 1; % range di valori randomizzati di prova [0, 2xe[
r = rand([1,5]);
w(1:length(r)) = 1 + (-w_max_step +  2*w_max_step*r);

load_system("simulazione_sistema_non_lineare");
mdl = "simulazione_sistema_non_lineare";

simIn(1:length(r)) = Simulink.SimulationInput(mdl);

for i = length(r):-1:1
    simIn(i) = setModelParameter(simIn(i),"Solver","ode45",...
    "StopTime","20");
    blk = strcat(mdl,"/Rif");
    simIn(i) = setBlockParameter(simIn(i),blk,"After",""+w(i));
end

%out = parsim(simIn, TransferBaseWorkspaceVariables="on");
out = sim(simIn,"UseFastRestart","on");


% retrieve outputs from simulations runs
runIDs = Simulink.sdi.getAllRunIDs;
for i = length(r):-1:1
    run = Simulink.sdi.getRun(runIDs(i));
    outSignal = getSignalByIndex(run,1);
    plotOnSubPlot(outSignal,1,1,true)
end
Simulink.sdi.view; bdclose();
