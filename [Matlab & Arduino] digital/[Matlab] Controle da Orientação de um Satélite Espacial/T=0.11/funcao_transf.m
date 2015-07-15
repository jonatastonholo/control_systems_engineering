clear all;
close all;
clc;

s=tf('s');
num = [0 0 10];
den = [1 10 9];

%------ Gs ---------------------------------
Gs = tf(num,den)

zerosS = zero(Gs)
polosS = pole(Gs)


%Espaço de estados
[A,B,C,D] = tf2ss(num, den)

%------ Gz ---------------------------------
T  = 0.11;
Gz = c2d(Gs, T, 'zoh')

zerosZ = zero(Gz)
polosZ = pole(Gz)

taos=zeros(size(polosZ));

for i=1 : size(polosZ)
    taos(i) = -T / log(polosZ(i));
end


%-------- Gw ---------------------------------
[nz,dz] = tfdata(Gz);

[nw,dw] = d2cm(nz{1},dz{1},T,'tustin');

Gw = tf(nw,dw)

zerosW = zero(Gw)
polosW = pole(Gw)
