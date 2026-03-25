% =========================================================
%  demoGaussJordan.m
%  Program Demo: Metode Eliminasi Gauss-Jordan
%  Kompatibel dengan MATLAB R2015a/b
%
%  Pastikan semua file berikut ada dalam satu folder:
%    - gaussJordan.m
%    - cetakRingkasan.m
%    - plotSistem2x2.m
%    - plotSistem3x3.m
%
%  Jalankan: demoGaussJordan
% =========================================================

clc;
clear;
close all;

fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*   DEMO PROGRAM: ELIMINASI GAUSS-JORDAN           *\n');
fprintf('*****************************************************\n\n');

% =========================================================
% KASUS 1: Sistem 3x3 — solusi unik
%   2x1 +  x2 -  x3 =  8
%  -3x1 -  x2 + 2x3 = -11
%  -2x1 +  x2 + 2x3 = -3
%  Solusi eksak: x1=2, x2=3, x3=-1
% =========================================================
fprintf('>>> KASUS 1: Sistem 3x3 (solusi unik)\n\n');

A1 = [ 2  1 -1;
      -3 -1  2;
      -2  1  2];
b1 = [8; -11; -3];

[x1, M1, sing1] = gaussJordan(A1, b1);
plotSistem3x3(A1, b1, x1, 'Kasus 1: Sistem 3x3');


% =========================================================
% KASUS 2: Sistem 4x4
%   Matriks yang butuh partial pivoting
%    x1 + 2x2 +  x3 +  x4 =  5
%   3x1 + 2x2 + 4x3 + 4x4 = 16
%   4x1 + 4x2 + 3x3 + 4x4 = 22
%   2x1 +  x3 + 5x4        = 15
% =========================================================
fprintf('\n>>> KASUS 2: Sistem 4x4\n\n');

A2 = [1 2 1 1;
      3 2 4 4;
      4 4 3 4;
      2 0 1 5];
b2 = [5; 16; 22; 15];

[x2, M2, sing2] = gaussJordan(A2, b2);
plotSistem3x3(A2, b2, x2, 'Kasus 2: Sistem 4x4');


% =========================================================
% KASUS 3: Sistem 2x2 — visualisasi geometri dua garis
%   2x + 3y = 7
%   4x -  y = 1
% =========================================================
fprintf('\n>>> KASUS 3: Sistem 2x2 (dengan visualisasi garis)\n\n');

A3 = [2  3;
      4 -1];
b3 = [7; 1];

[x3, M3, sing3] = gaussJordan(A3, b3);
plotSistem2x2(A3, b3, x3, 'Kasus 3: Sistem 2x2');


% =========================================================
% KASUS 4: Matriks SINGULAR
%    x +  y = 2
%   2x + 2y = 5   (inkonsisten)
% =========================================================
fprintf('\n>>> KASUS 4: Sistem SINGULAR\n\n');

A4 = [1 1;
      2 2];
b4 = [2; 5];

[x4, M4, sing4] = gaussJordan(A4, b4);


% =========================================================
% RINGKASAN SEMUA KASUS
% =========================================================
fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*   RINGKASAN SEMUA KASUS                          *\n');
fprintf('*****************************************************\n');
fprintf('  %-8s  %-10s  %-12s  %-10s\n', 'Kasus', 'Ukuran', 'Singular?', 'Solusi');
fprintf('  %s\n', repmat('-', 1, 55));
cetakRingkasan(1, '3x3', sing1, x1);
cetakRingkasan(2, '4x4', sing2, x2);
cetakRingkasan(3, '2x2', sing3, x3);
cetakRingkasan(4, '2x2', sing4, x4);
fprintf('*****************************************************\n\n');
