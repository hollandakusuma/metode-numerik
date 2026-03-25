% =========================================================
%  demoGaussJordan.m
%  Program Demo: Metode Eliminasi Gauss-Jordan
%  Kompatibel dengan MATLAB R2015a/b
%
%  File yang dibutuhkan dalam satu folder:
%    - gaussJordan.m   (function utama)
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
fprintf('>>> KASUS 1: Sistem 3x3 (solusi unik)\n');
fprintf('    2x1 +  x2 -  x3 =   8\n');
fprintf('   -3x1 -  x2 + 2x3 = -11\n');
fprintf('   -2x1 +  x2 + 2x3 =  -3\n\n');

A1 = [ 2  1 -1;
      -3 -1  2;
      -2  1  2];
b1 = [8; -11; -3];

[x1, ~, sing1] = gaussJordan(A1, b1);


% =========================================================
% KASUS 2: Sistem 3x3 yang butuh partial pivoting
%   Elemen (1,1) = 0 sehingga baris HARUS ditukar
%    0x1 + 2x2 +  x3 =  3
%    x1 +  x2 + 2x3  =  6
%   2x1 +  x2 + 3x3  =  9
%  Solusi: x1=1, x2=1, x3=1
% =========================================================
fprintf('\n>>> KASUS 2: Sistem 3x3 (pivot pertama = 0, HARUS tukar baris)\n');
fprintf('    0x1 + 2x2 +  x3 = 3\n');
fprintf('     x1 +  x2 + 2x3 = 6\n');
fprintf('    2x1 +  x2 + 3x3 = 9\n\n');

A2 = [0 2 1;
      1 1 2;
      2 1 3];
b2 = [3; 6; 9];

[x2, ~, sing2] = gaussJordan(A2, b2);


% =========================================================
% KASUS 3: Sistem 2x2 — sederhana
%   2x + 3y = 7
%   4x -  y = 1
%  Solusi: x=0.7143, y=1.8571
% =========================================================
fprintf('\n>>> KASUS 3: Sistem 2x2\n');
fprintf('    2x + 3y = 7\n');
fprintf('    4x -  y = 1\n\n');

A3 = [2  3;
      4 -1];
b3 = [7; 1];

[x3, ~, sing3] = gaussJordan(A3, b3);


% =========================================================
% KASUS 4: Matriks SINGULAR
%    x +  y = 2
%   2x + 2y = 5   (inkonsisten, tidak ada solusi)
% =========================================================
fprintf('\n>>> KASUS 4: Sistem SINGULAR (tidak ada solusi unik)\n');
fprintf('     x +  y = 2\n');
fprintf('    2x + 2y = 5\n\n');

A4 = [1 1;
      2 2];
b4 = [2; 5];

[x4, ~, sing4] = gaussJordan(A4, b4);


% =========================================================
% RINGKASAN SEMUA KASUS
% =========================================================
fprintf('*****************************************************\n');
fprintf('*   RINGKASAN SEMUA KASUS                          *\n');
fprintf('*****************************************************\n');
fprintf('  %-8s  %-8s  %-12s  %s\n', 'Kasus', 'Ukuran', 'Singular?', 'Solusi');
fprintf('  %s\n', repmat('-', 1, 58));

kasusData = {1, '3x3', sing1, x1;
             2, '3x3', sing2, x2;
             3, '2x2', sing3, x3;
             4, '2x2', sing4, x4};

for k = 1 : size(kasusData, 1)
    kasus     = kasusData{k, 1};
    ukuran    = kasusData{k, 2};
    isSing    = kasusData{k, 3};
    xHasil    = kasusData{k, 4};

    if isSing
        singStr = 'YA';
        solStr  = 'Tidak ada';
    else
        singStr = 'TIDAK';
        solStr  = '';
        for vi = 1 : length(xHasil)
            solStr = [solStr sprintf('x%d=%.4f ', vi, xHasil(vi))]; %#ok<AGROW>
        end
    end
    fprintf('  %-8d  %-8s  %-12s  %s\n', kasus, ukuran, singStr, solStr);
end

fprintf('*****************************************************\n\n');