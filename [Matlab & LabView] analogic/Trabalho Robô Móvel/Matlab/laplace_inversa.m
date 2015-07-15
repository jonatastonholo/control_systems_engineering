clc;
clear all;
close all;
syms s;
k=15;

imp=1;
step= (1/s);
ramp= (1/(s^2));

num = (k*((s+1)*(s+5)));
den = (s*(s+1.5)*(s+2));

Gsimp = imp* (num/den);
Gsstep = step* (num/den);
Gsramp = ramp* (num/den);

Gtimp = ilaplace(Gsimp);
Gtstep = ilaplace(Gsstep);
Gtramp = ilaplace(Gsramp);

