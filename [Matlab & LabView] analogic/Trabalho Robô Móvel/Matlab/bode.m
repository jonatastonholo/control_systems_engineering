clear all;
close all;
s=tf('s');
k=15;
num = (k*((s+1)*(s+5)));
den = (s*(s+1.5)*(s+2));

Gs = (num/den);
Gmf = (num) / (num+den);

figure(1);bode(Gs);legend('Bode para malha aberta');grid;
figure(2);bode(Gmf);legend('Bode para malha fechada');grid;