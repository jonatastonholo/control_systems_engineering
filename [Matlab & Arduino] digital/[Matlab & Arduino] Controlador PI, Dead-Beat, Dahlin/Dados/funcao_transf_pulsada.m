clear all;projeto_alocacao_polos;close all;clc;


T = 0.00664;

Gz = c2d(Gps, T, 'zoh')

%---Ref
%t = 0:T:1; % vetor de tempo
t = 0:T:100*T;
r = V*ones(1,length(t));
y = lsim(Gz,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferença entre referência e saída

LInfo = lsiminfo(y)
LInfoGps


subplot(211),plot(t,r);
hold on;
stem(t,y);
axis([0 Tf 0 V+1]);
set(gca,'YTick', 0:.5:V+1);
set(gca,'XTick', 0:.05:Tf);
xlabel('Tempo (s)');
ylabel('Tensão (V)');
title('Resposta de G(z) ao degrau de 3 volts');
legend('Referência de 3v','Resposta de G(z) ao degrau');
grid;

subplot(212);
ps = plot(t,y,'Color','r');
axis([0 Tf 0 V+1]);
set(gca,'YTick', 0:.5:V+1);
set(gca,'XTick', 0:.05:Tf);
hold on;
plot(t,r,'Color','b');
axis([0 Tf 0 V+1]);
set(gca,'YTick', 0:.5:V+1);
set(gca,'XTick', 0:.05:Tf);
title('Simulação - Resposta de Gp(s) ao Degrau de 3 volts');
legend('Degrau de 3v','Resposta ao degrau em Malha Aberta');
xlabel('Tempo (s)');
ylabel('Tensao (V)')
grid;