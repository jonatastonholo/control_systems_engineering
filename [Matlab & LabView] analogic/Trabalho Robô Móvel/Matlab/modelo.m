clear all;
close all;
s=tf('s');
k=15;
num = (k*((s+1)*(s+5)));
den = (s*(s+1.5)*(s+2));

Gs = (num/den);
Gmf = (num) / (num+den);
figure(1);impulse(Gs);grid;legend('Impulso em malha aberta');
figure(2);step(Gs);grid;legend('Degrau em malha aberta');
figure(3);step(Gmf);grid;legend('Degrau em malha fechada');
figure(4);impulse(Gmf);grid;legend('Impulso em malha fechada');
