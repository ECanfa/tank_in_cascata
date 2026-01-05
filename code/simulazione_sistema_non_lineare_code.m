close all; clear; clc;

path_to_constants="tank_in_cascata_costanti.m";
run("tank_in_cascata_costanti.m");

% Costanti e Parametri di Simulazione
N = 0;
Dist = 0;
W = 1;
U = [0 1];

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
% Supponendo un riferimento w(t) = 1(t), esplorare il range di condizioni iniziali dello stato del sistema
% non lineare (nell'intorno del punto di equilibrio) tali per cui l'uscita del sistema in anello chiuso converga
% a h(xe, ue).

Simulink.sdi.clear;


x1_max_noise = xe(1); % range di valori randomizzati di prova [0, 2xe[
x2_max_noise = xe(2);
r = rand([1,5]);
x1(1:length(r)) = xe(1) + (-x1_max_noise  + 1.5*r*x1_max_noise);
x2(1:length(r)) = xe(2) + (-x2_max_noise + 1.5*r*x2_max_noise);


load_system("simulazione_sistema_non_lineare");
mdl = "simulazione_sistema_non_lineare";

simIn(1:(length(r))) = Simulink.SimulationInput(mdl);

for i = (length(r)):-1:1
    simIn(i) = setModelParameter(simIn(i),"Solver","ode45",...
    "StopTime","10");
     simIn(i) = setModelParameter(simIn(i),FixedStep="0.1");
    blk = strcat(mdl,"/Constant1");
    simIn(i) = setBlockParameter(simIn(i),blk,"Value","["+x1(1,i)+" "+x2(1,i)+ "]");
    if i== length(r)+1
      simIn(i) = setBlockParameter(simIn(i),blk,"Value","["+xe(1)+" "+xe(2)+ "]");
    end
   
end

Simulink.sdi.clear;
out = sim(simIn);%,"UseFastRestart","on");
%out = parsim(simIn,"UseFastRestart","on","TransferBaseWorkspaceVariables", "on");
runIDs = Simulink.sdi.getAllRunIDs;

figure(1); hold on; grid on;

legend_step = strings(1,length(runIDs)); 

for i = 1:length(runIDs)
    run = Simulink.sdi.getRun(runIDs(i));
    outSignal = getSignalByIndex(run,1);

    t = outSignal.Values.Time;
    %necessario uso di squeeze su outSignal.Values.Data perchè vettore
    %3D [campione, singleton, valori]
    y = squeeze(outSignal.Values.Data);
    y = y(:,1);   % effettivi valori di cui fare il plot
    legend_step(i) = "x0(1):" + string(x1(1,i)) + " x0(2):" + string(x2(1,i));
    plot(t,y)
end


%simulazione con ingresso a gradino e stato iniziale uguale allo stato di
%equilibrio
legend(legend_step');

%% 
% Esplorare il range di ampiezza di riferimenti a gradino tali per cui il controllore rimane efficace sul
% sistema non lineare.

w_max_step = 1; % range di valori randomizzati di prova [0, 2xe[
r = rand([1,5]);
w(1:length(r)) = r*w_max_step;

load_system("simulazione_sistema_non_lineare");
mdl = "simulazione_sistema_non_lineare";

simIn(1:length(r)) = Simulink.SimulationInput(mdl);

for i = length(r):-1:1
    simIn(i) = setModelParameter(simIn(i),"Solver","ode45",...
    "StopTime","10");
    blk = strcat(mdl,"/Rif");
    simIn(i) = setBlockParameter(simIn(i),blk,"After",num2str(w(i)));
end

Simulink.sdi.clear;
out = sim(simIn,"UseFastRestart","on");
%out = parsim(simIn,"UseFastRestart","on","TransferBaseWorkspaceVariables", "on");
runIDs = Simulink.sdi.getAllRunIDs;

figure(2); hold on; grid on;

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
    legend("Ampiezza del gradino "+w(i));
end

