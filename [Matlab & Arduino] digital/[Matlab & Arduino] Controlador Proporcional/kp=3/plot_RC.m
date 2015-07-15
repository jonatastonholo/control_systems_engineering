close all;
clear all;

%Entrada Analogica
dadosEntrAnalog = csvread('REF/F0002CH1.csv');
tensaoEntrAnalog = dadosEntrAnalog(1:size(dadosEntrAnalog), 2);
%tensaoEntrAnalog = tensaoEntrAnalog + .72;
tempoEntrAnalog =  dadosEntrAnalog(1:size(dadosEntrAnalog), 1);
%tempoEntrAnalog = tempoEntrAnalog +6.4e-8;

%Entrada Digital Arduino (PWM)
dadosEntrDig = csvread('ATU/F0003CH1.csv');
tensaoPWM = dadosEntrDig(1:size(dadosEntrDig), 2);
%tensaoPWM = tensaoPWM + .72;
tempoPWM =  dadosEntrDig(1:size(dadosEntrDig), 1);
%tempoPWM = tempoPWM +6.4e-8;

dadosSaidaInd = csvread('ATU/F0003CH2.csv');
tensaoSaida = dadosSaidaInd(1:size(dadosSaidaInd), 2);
%tensaoSaida = tensaoSaida + .72;
tempoSaida =  dadosSaidaInd(1:size(dadosSaidaInd), 1);
%tempoSaida = tempoSaida +6.4e-8;

%Calculo da media do PWM ao longo do tempo

tempoZero = find(tempoEntrAnalog==0);
tmp= tensaoPWM(tempoZero:end);
mediaPWM = zeros(size(tmp));
for i=1:size(tmp,1)    
    mediaPWM(i) = mean(tmp(max(i-200,1):i));
end;
tempoIni = find(tempoEntrAnalog==-3e-3);
figure(1);plot(tempoEntrAnalog(tempoIni:end),tensaoEntrAnalog(tempoIni:end),'Color',[1,0,0]);
hold on;
%plot(tempoPWM(tempoIni:end),tensaoPWM(tempoIni:end),'Color',[0,.7,0.5]);
plot(tempoSaida(tempoIni:end),tensaoSaida(tempoIni:end));
%plot(tempoPWM(tempoZero:end),mediaPWM,'m');

somaPWM_saida_media = [zeros(size(tensaoSaida) - size(mediaPWM),1); mediaPWM]+tensaoSaida;

%plot(tempoPWM(tempoIni:end),somaPWM_saida_media(tempoIni:end),'k');



%************************************* Simulacao **********************************************
s=tf('s');
R=100e3;
C=220E-9;
kp=3;
num = kp;
den = R*C*s + 1 + kp;


Hs = (num / den);
y = lsim(Hs,tensaoEntrAnalog,tempoEntrAnalog);
plot(tempoEntrAnalog(tempoIni:end),y(tempoIni:end),'Color',[.2,.5,.2]);
%**********************************************************************************************



legend('Tensao Entrada Gerador de Onda','Tensao Saida no Capacitor','Simulacao');
%legend('Tensao Entrada Gerador de Onda','Tensao Gerada pelo Arduino (PWM)','Tensao Saida no Capacitor','Media movel PWM','Soma entre Saida no Capacitor e Media PWM','Simulacao');
grid;
xlabel('Tempo (s)');
ylabel('Tensao (V)');
title('Entrada vs Saida no Capacitor - Kp=3');



figure(2);plot(tempoPWM(tempoZero:end),mediaPWM,'r');
hold on;
grid;
plot(tempoPWM(tempoZero:end),tmp);

xlabel('Tempo (s)');
ylabel('Tensao (V)');
title('Media Movel PWM vs Entrada PWM');