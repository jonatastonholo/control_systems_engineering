clear all;
close all;

s=tf('s');
R=100e3;
C=220E-9;
kp=1;
num = kp;
den = R*C*s + 1 + kp;

dadosEntrAnalog = csvread('REF/F0002CH1.csv');
u = dadosEntrAnalog(1:size(dadosEntrAnalog), 2);
t =  dadosEntrAnalog(1:size(dadosEntrAnalog), 1);

Hs = (num / den);
%t = 0:1E-8:4.5E-4;
%u = 1.5*square(1.1E-2*t);
y = lsim(Hs,u,t);
plot(t,y);
legend('Entrada');
xlabel('Tempo (s)');
ylabel('Tensao (V)');
grid;
hold on;
plot(t,u,'r');legend('Saida no Capacitor')