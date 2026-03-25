close all
clear
clc

A=[4 -2 -3 6; -6 7 6.5 -6; 1 7.5 6.25 5.5; -12 22 15.5 -1];
B = [12; -6.5; 16; 17];

solusiA=Gauss(A,B);
disp(solusiA)