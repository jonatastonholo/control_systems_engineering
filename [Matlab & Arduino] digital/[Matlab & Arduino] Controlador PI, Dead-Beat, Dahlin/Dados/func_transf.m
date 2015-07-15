close all;
clear all;
clc;
R=100e3;
C=220e-9;

A = ([-2 1; 1 -1])*(1/(R*C));
B = ([1;0])*(1/(R*C));
C = ([0 1]);
D = [0];

[num,den] = ss2tf(A,B,C,D);

Hs = tf(num,den)

roots(den)

%step(Hs);
%grid;