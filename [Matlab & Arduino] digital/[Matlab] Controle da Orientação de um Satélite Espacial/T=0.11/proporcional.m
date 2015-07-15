clear all;
close all;
funcao_transf;

kp = 17.2132;


Gmf = feedback(Gs,1);
Gzmf = feedback(kp*Gz,1)

zerosGzmf = zero(Gzmf)
polosGzmf = pole(Gzmf)

%---Ref
%t = 0:T:1; % vetor de tempo
t = 0:T:6;
r = ones(1,length(t)); % vetor de 'uns' => degrau unitário no tempo

y = lsim(Gzmf,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferença entre referência e saída
c = kp*e; % erro multiplicado pela função de transf. do controlador: D(z) = Kp


subplot(411),stem(t,r);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Referência');

subplot(412),stem(t,y);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Saída - Resposta de Kp*Gmf(z) de malha fechada ao Degrau unitário com Controlador Proporcional para T = 0.11 seg');

subplot(413),stem(t,e);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Erro');

subplot(414),stem(t,c);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Sinal de Controle');