clear all; funcao_transf_pulsada; close all; clc;

%Entrada
dadosEntrada = csvread('dados_PI/F0000CH1.csv');
tensaoEntrada = dadosEntrada(1:size(dadosEntrada), 2);
tensaoEntrada = tensaoEntrada - 0.16;

tempoEntrada =  dadosEntrada(1:size(dadosEntrada), 1);
tie = find(tempoEntrada==1.014);
tempoEntrada = tempoEntrada - 1.014;

%Resposta ao degrau
dadosSaida = csvread('dados_PI/F0000CH2.csv');
tensaoSaida = dadosSaida(1:size(dadosSaida), 2);
tensaoSaida = tensaoSaida - 0.24;
tempoSaida =  dadosSaida(1:size(dadosSaida), 1);

Tf = 1.4850;
tis = find(tempoSaida==1.014);
tempoSaida = tempoSaida -1.014;
tif = find(tempoSaida == Tf);


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
% a=tis
% while(tensaoSaida(a) < tensaoSaida(end)*.63) 
%      a = a+1;
% end
% update_data_cursor(pa,tempoSaida(a),tensaoSaida(a));

grid;
legend('Degrau de 3v','Resposta ao degrau ');
title('Amostragem - Resposta de Gp(s) ao Degrau de 3 volts');
xlabel('Tempo (s)');
ylabel('Tensao (V)')



%-------------- Simulação ------------------
Kp = .049835;
Ki = 15.0106;

z=zpk('z',T);

numDzi = z;
denDzi = z-1;
Dzi = numDzi / denDzi

Dz = Kp + (Ki*T)*Dzi

zerosD = zero(Dz)
polesD = pole(Dz)

Mz = feedback(Dz*Gz,1)

%---Ref
%t = 0:T:1; % vetor de tempo
t = 0:T:1000*T;
r = V*ones(1,length(t)); % vetor de 'uns' => degrau unitário no tempo
y = lsim(Mz,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferença entre referência e saída
LinfoMz = lsiminfo(y)

[num_Dz,den_Dz] = tfdata(Dz, 'v');
c = dlsim(num_Dz, den_Dz, r' - y);
%c = Dz*e; % erro multiplicado pela função de transf. do controlador: D(z)


subplot(212),plot(t,r);hold on;
stem(t,y);grid;
axis([0 Tf 0 V+1]);
set(gca,'YTick', 0:.5:V+1);
set(gca,'XTick', 0:.05:Tf);
legend('Degrau de 3v','Resposta ao degrau ');
title('Simulação - Resposta de Gp(s) ao Degrau de 3 volts');
xlabel('Tempo (s)');
ylabel('Tensao (V)')