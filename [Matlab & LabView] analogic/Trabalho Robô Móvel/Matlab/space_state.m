clear all;
clc;
num = [15,90,75];
den = [1,3.5,3,0];

[A,B,C,D] = tf2ss(num,den);