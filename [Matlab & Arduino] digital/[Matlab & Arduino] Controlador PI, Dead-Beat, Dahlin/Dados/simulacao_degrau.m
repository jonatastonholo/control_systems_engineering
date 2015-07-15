clear all;
close all;

s=tf('s');

num = 2066;
den = (s+119.0015)*(s+17.3621);

Gs = num/den

step(Gs);
grid;
title('Resposta de G(s) ao Degrau Unitário');
figure;
rlocus(Gs);