clear all;
close all;
funcao_transf;

%----------- Gs Aberta -----------------------------------------------
subplot(211),step(Gs);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Resposta de G(s) de malha aberta ao Degrau unitário');

%subplot(211), step(Gs);
%grid;
%subplot(212), rlocus(Gs);

%----------- Gz Aberta -----------------------------------------------
t = 0:T:8;
r = ones(1,length(t)); % vetor de 'uns' => degrau unitário no tempo

y = lsim(Gz,r,t); % resposta ao degrau da malha fechada

subplot(212),stem(t,y);grid;
xlabel('Tempo (s)');
ylabel('Posição do Satélite');
title('Resposta de G(z) de malha aberta ao Degrau unitário para T = 0.222');

%-----------  Rlocus Gz  -----------------------------------------------
figure;rlocus(Gz);grid;

