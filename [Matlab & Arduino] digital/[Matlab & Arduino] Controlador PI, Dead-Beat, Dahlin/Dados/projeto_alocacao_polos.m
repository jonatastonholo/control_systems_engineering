clear all;
close all;
%Entrada
dadosEntrada = csvread('dados_alocacao_polos/F0000CH1.csv');
tensaoEntrada = dadosEntrada(1:size(dadosEntrada), 2);
tensaoEntrada = tensaoEntrada - 0.12;

tempoEntrada =  dadosEntrada(1:size(dadosEntrada), 1);
tie = find(tempoEntrada==.2916);
tempoEntrada = tempoEntrada - .2916;

%Resposta ao degrau
dadosSaida = csvread('dados_alocacao_polos/F0000CH2.csv');
tensaoSaida = dadosSaida(1:size(dadosSaida), 2);
tensaoSaida = tensaoSaida - 0.16;
tempoSaida =  dadosSaida(1:size(dadosSaida), 1);

Tf = .7080;
tis = find(tempoSaida==.2916);
tempoSaida = tempoSaida - .2916;
tif = find(tempoSaida == Tf);
V=3;

subplot(211),
plot(tempoEntrada(tie:tif),tensaoEntrada(tie:tif));
%plot(tempoEntrada,tensaoEntrada);
axis([0 Tf 0 V+1]);
set(gca,'YTick', 0:.5:V+1);
set(gca,'XTick', 0:.05:Tf);

%plot(tempoEntrada,tensaoEntrada);
hold on;
pa = plot(tempoSaida(tis:tif),tensaoSaida(tis:tif),'Color','r');
%pa = plot(tempoSaida,tensaoSaida,'Color','r');
axis([0 Tf 0 V+1]);
set(gca,'YTick', 0:.5:V+1);
set(gca,'XTick', 0:.05:Tf);


%Achando Constante de Tempo
a=tis
while(tensaoSaida(a) < tensaoSaida(end)*.63) 
     a = a+1;
end
update_data_cursor(pa,tempoSaida(a),tensaoSaida(a));

grid;
legend('Degrau de 3v','Resposta ao degrau ');
title('Amostragem - Resposta de Gp(s) ao Degrau de 3 volts');
xlabel('Tempo (s)');
ylabel('Tensao (V)')



%------------ Simulação --------------
s=tf('s');

num = 2066;
den = (s+119.0015)*(s+17.3621);
Gs = num/den;
P = [(-17.3621 + 50i) (-17.3621 - 50i)];
numD = (s+17.3621)*(s+119.0015);
denD = (s+ 17.3621 + 50i)*(s+ 17.3621 - 50i);
Ds = numD/denD

R=100e3;
C=220e-9;

A = ([-2 1; 1 -1])*(1/(R*C));
B = ([1;0])*(1/(R*C));
C = ([0 1]);
D = [0];

K = place(A,B,P)


A1 = A - B*K;

[num1,den1] = ss2tf(A1,B,C,D);
sys = ss(A1,B,C,D);

Gps = tf(num1,den1)

%simulando step
t = 0:.01:Tf;
r = V*ones(1,length(t));

y = lsim(Gps,r,t);
LInfoGps = lsiminfo(y)

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


%Achando Constante de Tempo
i=1
while(y(i) < LInfoGps.Max*.63) 
    i = i+1;
end
Tao = t(i);
update_data_cursor(ps,Tao,y(i));

% [Vc2,t,X] = lsim(sys,V*ones(size(t)),t,[0 0]);

% Y = K(1)*X(:,1) + K(2)*X(:,2);
% 
% subplot(212);
% plot(t,3-Y);
% title('Simulação - Acao de controle de Gp(s) con entrada de 3 V');
% legend('Resposta ao degrau em Malha Aberta');
% xlabel('Tempo (s)');
% ylabel('Tensao (V)')
% grid;