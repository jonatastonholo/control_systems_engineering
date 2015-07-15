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
r = ones(1,length(t)); % vetor de 'uns' => degrau unit�rio no tempo

y = lsim(Gzmf,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferen�a entre refer�ncia e sa�da
c = kp*e; % erro multiplicado pela fun��o de transf. do controlador: D(z) = Kp


subplot(411),stem(t,r);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Refer�ncia');

subplot(412),stem(t,y);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Sa�da - Resposta de Kp*Gmf(z) de malha fechada ao Degrau unit�rio com Controlador Proporcional para T = 0.11 seg');

subplot(413),stem(t,e);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Erro');

subplot(414),stem(t,c);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Sinal de Controle');