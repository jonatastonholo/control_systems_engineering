clear all;
close all;
clc;

funcao_transf;

z = zpk('z', T);

Taod = 0.1111;
q=exp(-T/Taod);

nD = (1-q);
dD = (z-1);

Dz = (1/Gz) * (nD/dD)

zeros = zero(Dz)
poles = pole(Dz)


Mz = feedback(Dz*Gz,1)

%---Ref
%t = 0:T:1; % vetor de tempo
t = 0:T:6;
r = ones(1,length(t)); % vetor de 'uns' => degrau unit�rio no tempo

y = lsim(Mz,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferen�a entre refer�ncia e sa�da

[num_Dz,den_Dz] = tfdata(Dz, 'v');
c = dlsim(num_Dz, den_Dz, r' - y);
%c = Dz*e; % erro multiplicado pela fun��o de transf. do controlador: D(z)


subplot(411),stem(t,r);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Refer�ncia');

subplot(412),stem(t,y);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Sa�da - Resposta de D(z)*G(z) de malha fechada ao Degrau unit�rio com Controlador de Dahlim para T=0.222 seg');

subplot(413),stem(t,e);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Erro');

subplot(414),stem(t,c);grid;
xlabel('Tempo (s)');
ylabel('Posi��o do Sat�lite');
title('Sinal de Controle');