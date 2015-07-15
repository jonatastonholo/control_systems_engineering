clc
clear all;
close all;

num = 1;
den = [1 3 2];

% Função de transferencia continua %
Ft = tf(num,den);
step (Ft);

% Tempo de amostragem %
T = 0.3160; 

% Função de transferencia discreta %
Gz = c2d(Ft, T, 'zoh')

t = 0:T:10;
figure(2)
lsim(Ft,Gz,ones(1,length(t)),t);

% Estabilidade pelo Critério RH %
[numW, denW] = d2cm(Gz.num,Gz.den,T,'Tustin')
Gw = tf(numW, denW);

% Lugar das raízes %
figure(3)
rlocus(Gz)
figure(4)
rlocus(Gw)

% Controlador com erro de posição menor que 5% %

% Kp < 0.0751 para o sistema ter um erro menor que 5% 

Kp = 0.0751;
t = 0:T:5;

C = pid(Kp); %  PID(Kp) returns a proportional only controller

% Função de transferencia em malha fechada
Dz = feedback(C*Gz,1);

u = ones(1,length(t));
[numDz, denDz] = tfdata(Dz,'v');
y = dlsim(numDz, denDz,u);
figure(5)
subplot(2,2,1);
stem(t,u);
title('Referencia');
subplot(2,2,2);
e = u'-y;
stem(t,e);
title('Erro');
subplot(2,2,3);
stem(t,y);
title('Saida');
subplot(2,2,4);
step(Dz);
title('Controle');




