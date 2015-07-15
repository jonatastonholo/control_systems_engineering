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
r = ones(1,length(t)); % vetor de 'uns' => degrau unitário no tempo

y = lsim(Mz,r,t); % resposta ao degrau da malha fechada
e = r' - y; % diferença entre referência e saída

[num_Dz,den_Dz] = tfdata(Dz, 'v');
c = dlsim(num_Dz, den_Dz, r' - y);
%c = Dz*e; % erro multiplicado pela função de transf. do controlador: D(z)


subplot(411),stem(t,r);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Referência');

subplot(412),stem(t,y);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Saída - Resposta de D(z)*G(z) de malha fechada ao Degrau unitário com Controlador de Dahlim para T=0.222 seg');

subplot(413),stem(t,e);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Erro');

subplot(414),stem(t,c);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Sinal de Controle');