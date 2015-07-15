close all;
clear all;

%Entrada
dadosEntrada = csvread('malha_aberta/F0000CH1.csv');
tensaoEntrada = dadosEntrada(1:size(dadosEntrada), 2);
tensaoEntrada = tensaoEntrada - 0.4;

tempoEntrada =  dadosEntrada(1:size(dadosEntrada), 1);
tie = find(tempoEntrada==-.0002);
tempoEntrada = tempoEntrada + .0002;



%Resposta ao degrau
dadosSaida = csvread('malha_aberta/F0000CH2.csv');
tensaoSaida = dadosSaida(1:size(dadosSaida), 2);
tensaoSaida = tensaoSaida - 0.4;
tempoSaida =  dadosSaida(1:size(dadosSaida), 1);

Tf = .4004;
tis = find(tempoSaida==-.0002);
tempoSaida = tempoSaida + .0002;
tif = find(tempoSaida == Tf);


subplot(211),
plot(tempoEntrada(tie:tif),tensaoEntrada(tie:tif));
axis([0 Tf 0 6]);
set(gca,'YTick', 0:.5:6);
set(gca,'XTick', 0:.05:Tf);

%plot(tempoEntrada,tensaoEntrada);
hold on;
pa = plot(tempoSaida(tis:tif),tensaoSaida(tis:tif),'Color','r');
axis([0 Tf 0 6]);
set(gca,'YTick', 0:.5:6);
set(gca,'XTick', 0:.05:Tf);
%plot(tempoSaida,tensaoSaida,'Color','r');

%Achando Constante de Tempo
i=1
while(tensaoSaida(i) < tensaoSaida(end)*.63) 
    i = i+1;
end
update_data_cursor(pa,tempoSaida(i),tensaoSaida(i));

grid;
legend('Degrau de 5v','Resposta ao degrau em Malha Aberta');
title('Amostragem - Resposta de G(s) ao Degrau de 5 volts');
xlabel('Tempo (s)');
ylabel('Tensao (V)')



%------------ Simulação --------------
s=tf('s');

t = 0:.001:Tf;
r = 5*ones(1,length(t));

num = 2066;
den = (s+119.0015)*(s+17.3621);

Gs = num/den;
y = lsim(Gs,r,t);
LsimInfoY = lsiminfo(y,t)

ti = t(1);

subplot(212),
ps = plot(t,y,'Color','r');
axis([0 Tf 0 6]);
set(gca,'YTick', 0:.5:6);
set(gca,'XTick', 0:.05:Tf);
hold on;
plot(t,r,'Color','b');
axis([0 Tf 0 6]);
set(gca,'YTick', 0:.5:6);
set(gca,'XTick', 0:.05:Tf);

%Achando Constante de Tempo
i=1
while(y(i) < LsimInfoY.Max*.63) 
    i = i+1;
end
update_data_cursor(ps,t(i),y(i));


grid;
title('Simulação - Resposta de G(s) ao Degrau de 5 volts');
legend('Degrau de 5v','Resposta ao degrau em Malha Aberta');
xlabel('Tempo (s)');
ylabel('Tensao (V)')

