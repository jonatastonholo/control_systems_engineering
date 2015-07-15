clear all;funcao_transf_pulsada;close all;clc;
%Entrada
dadosEntrada = csvread('dados_dahlin/F0000CH1.csv');
tensaoEntrada = dadosEntrada(1:size(dadosEntrada), 2);
%tensaoEntrada = tensaoEntrada - 0.16;

tempoEntrada =  dadosEntrada(1:size(dadosEntrada), 1);
tie = find(tempoEntrada==0.381);
tempoEntrada = tempoEntrada - 0.381;

%Resposta ao degrau
dadosSaida = csvread('dados_dahlin/F0000CH2.csv');
tensaoSaida = dadosSaida(1:size(dadosSaida), 2);
%tensaoSaida = tensaoSaida - 0.24;
tempoSaida =  dadosSaida(1:size(dadosSaida), 1);

Tf = 1.368;
tis = find(tempoSaida==0.381);
tempoSaida = tempoSaida -0.381;
tif = find(tempoSaida == Tf);


plot(tempoEntrada(tie:tif),tensaoEntrada(tie:tif));
%plot(tempoEntrada,tensaoEntrada);
% axis([0 Tf 0 V+1]);
% set(gca,'YTick', 0:.5:V+1);
% set(gca,'XTick', 0:.05:Tf);

hold on;
pa = plot(tempoSaida(tis:tif),tensaoSaida(tis:tif),'Color','r');
%pa = plot(tempoSaida,tensaoSaida,'Color','r');
% axis([0 Tf 0 V+1]);
% set(gca,'YTick', 0:.5:V+1);
% set(gca,'XTick', 0:.05:Tf);


%Achando Constante de Tempo
a=tis
while(tensaoSaida(a) < ((tensaoSaida(end)+ 2.12)*.63)) 
      a = a+1;
end
update_data_cursor(pa,tempoSaida(a),tensaoSaida(a));

grid;
legend('Degrau de 3v','Resposta ao degrau ');
title('Amostragem - Resposta do controlador de Dahlin ao Degrau de 3 volts');
xlabel('Tempo (s)');
ylabel('Tensao (V)')


%--------------- Simulação --------------
figure;
z = zpk('z', T);

Taod = 150e-3;
q=exp(-T/Taod);

nD = (1-q);
dD = (z-1);

Dz = (1/Gz) * (nD/dD)

zerosD = zero(Dz)
polesD = pole(Dz)


Mz = feedback(Dz*Gz,1)

%---Ref
%t = 0:T:1; % vetor de tempo
t = 0:T:100*T;
r = [zeros(1,floor(length(t)/2)) ones(1,ceil(length(t)/2))] + 2*ones(1,length(t)); % vetor de 'uns' => degrau unitário no tempo
%r = ones(1,length(t)); % vetor de 'uns' => degrau unitário no tempo
y = lsim(Mz,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferença entre referência e saída

[num_Dz,den_Dz] = tfdata(Dz, 'v');
c = dlsim(num_Dz, den_Dz, r' - y);
%c = Dz*e; % erro multiplicado pela função de transf. do controlador: D(z)

figure;
subplot(411),stem(t,r);grid;
xlabel('Tempo (s)');
ylabel('Tensão (v)');
title('Referência');

subplot(412),stem(t,y);grid;
xlabel('Tempo (s)');
ylabel('Tensão (v)');
title('Saída - Resposta de D(z)*G(z) de malha fechada ao Degrau unitário com Controlador de Dahlim');

subplot(413),stem(t,e);grid;
xlabel('Tempo (s)');
ylabel('Tensão (v)');
title('Erro');

subplot(414),stem(t,c);grid;
xlabel('Tempo (s)');
ylabel('Tensão (v)');
title('Sinal de Controle');