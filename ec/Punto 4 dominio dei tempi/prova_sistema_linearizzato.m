k1=1;
k2=0.30;
k3=0.45;
k4=0.50;

xe=[9.45, 4.20];
ue=(k1/k4)*sqrt(xe(1));

%Matrici del sistema linearizzato

A=[-k1/(2*sqrt(xe(1))), 0; k2/(2*sqrt(xe(1))), -k3/(2*sqrt(xe(2)))];
B=[k4; 0];
C=[0, 1];
D=0;

modello = ss(A,B,C,D);

%Definizione spazio degli stati
G = tf(modello);

%Testare sul sistema in anello chiuso
R = 1;

% (luci) 12/28 test con nuovo regolatore
S_star = 30;
T_a_5_star = 0.050;
xi_star  = abs(log(S_star/100))/(sqrt(pi^2 + log(S_star/100)^2));
M_f_min = 100*xi_star;
    
omega_c_min = 300/(M_f_min*T_a_5_star);

omega_c_star = omega_c_min;%+ (omega_c_max - omega_c_min)/4;
mu_omega_c_star = 1/abs(evalfr(G,omega_c_star));
mu_R = max(0, mu_omega_c_star/abs(evalfr(G, 0)));
RR_s = mu_R;

phi_star = pi/4;
cos_phi_star = cos(phi_star);
sin_phi_star = sin(phi_star);
M_star = 1/(cos(phi_star))+0.01;

T_zero_Rd = (M_star - cos_phi_star)/(omega_c_star*sin_phi_star);
T_polo_Rd = (cos(phi_star) - 1/M_star)/(omega_c_star*sin_phi_star);

s = tf('s');
RR_d = 1*(1+T_zero_Rd*s)/(1+T_polo_Rd*s);

RR = RR_s*RR_d;

L = RR*G;
F = L/(1+L);

% Risposta a w(t) riferimento
W = 3.5;
T_simulation = 2*T_a_5_star;
[y_step,t_step] = step(W*F, T_simulation);
plot(t_step,y_step,'b');
grid on, zoom on, hold on;

%teorema del valore finale
% W/s*F*s=WF => LV;
LV = evalfr(W*F,0);

% vincolo sovraelongazione
patch([0,T_simulation,T_simulation,0],[LV*(1+S_star/100),LV*(1+S_star/100),LV*2,LV*2],'r','FaceAlpha',0.3,'EdgeAlpha',0.5);

% vincolo tempo di assestamento al 5%
patch([T_star,T_simulation,T_simulation,T_star],[LV*(1-0.05),LV*(1-0.05),0,0],'g','FaceAlpha',0.1,'EdgeAlpha',0.5);
patch([T_star,T_simulation,T_simulation,T_star],[LV*(1+0.05),LV*(1+0.05),LV*2,LV*2],'g','FaceAlpha',0.1,'EdgeAlpha',0.1);

ylim([0,LV*2]);

Legend_step = ["Risposta al gradino"; "Vincolo sovraelongazione"; "Vincolo tempo di assestamento"];
legend(Legend_step);

figure(2);

S = 1/(1+L);
% Check Disturbo (Da controllare)
D = 1.5;
tt = 0:1e-2:2e2;
d_t = 0;
for n = 1:4
    omega_d = 0.4*n;
    d_t = d_t + D*sin(omega_d*tt); %trasformata di sin(wt)sca(t) 
end
y_d = lsim(S,d_t,tt);
hold on, grid on, zoom on
plot(tt,d_t,'m');
plot(tt,y_d,'b');
grid on;
legend('d(t)','y_d(t)');

% Check Disturbo di Misura
% (luci)
% Da controllare, pero il fatto che modulo sia cosi negativo ha senso

figure(3);
N = 0.1;
n_t = 0;
for n = 1:4
    omega_n = 2*10^5*n;
    n_t = n_t + N*sin(omega_n*tt); 
end

y_n = lsim(-F,n_t,tt);
hold on, grid on, zoom on
plot(tt,n_t,'m');
plot(tt,y_n,'b');
grid on;
legend('n(t)','y_n(t');