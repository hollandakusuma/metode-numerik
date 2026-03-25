% =========================================================
%  demoGaussSeidel.m
%  Program Demo: Metode Iterasi Gauss-Seidel
%  Kompatibel dengan MATLAB R2015a/b
%
%  File yang dibutuhkan dalam satu folder:
%    - gaussSeidel.m   (function utama)
%
%  Jalankan: demoGaussSeidel
% =========================================================

clc;
clear;
close all;

fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*     DEMO PROGRAM: ITERASI GAUSS-SEIDEL           *\n');
fprintf('*****************************************************\n\n');

% =========================================================
% KASUS 1: Sistem 3x3 — strictly diagonally dominant
%   4x1 -  x2        =  3
%  - x1 + 4x2 -  x3  =  6
%         - x2 + 4x3  =  3
%  Solusi eksak: x1=1.5, x2=3, x3=1.5
%  (sama dengan demo Jacobi — bisa dibandingkan iterasinya)
% =========================================================
fprintf('>>> KASUS 1: Sistem 3x3 (dominan diagonal, konvergen)\n');
fprintf('    4x1 -  x2        =  3\n');
fprintf('   - x1 + 4x2 -  x3 =  6\n');
fprintf('          -x2 + 4x3  =  3\n\n');

A1  = [ 4 -1  0;
       -1  4 -1;
        0 -1  4];
b1  = [3; 6; 3];
x01 = [0; 0; 0];

[x1, tabel1, ok1] = gaussSeidel(A1, b1, x01, 1e-6, 50);


% =========================================================
% KASUS 2: Sistem 4x4
%  10x1 -  x2 +  2x3        =   6
%  - x1 + 11x2 -  x3 + 3x4 =  25
%   2x1 -  x2 + 10x3 -  x4 = -11
%          3x2 -  x3 +  8x4 =  15
%  Solusi: x1=1, x2=2, x3=-1, x4=1
% =========================================================
fprintf('\n>>> KASUS 2: Sistem 4x4\n');
fprintf('   10x1 -  x2 +  2x3        =   6\n');
fprintf('   - x1 + 11x2 -  x3 + 3x4 =  25\n');
fprintf('    2x1 -  x2 + 10x3 -  x4 = -11\n');
fprintf('           3x2 -  x3 +  8x4 =  15\n\n');

A2  = [10 -1  2  0;
       -1 11 -1  3;
        2 -1 10 -1;
        0  3 -1  8];
b2  = [6; 25; -11; 15];
x02 = [0; 0; 0; 0];

[x2, tabel2, ok2] = gaussSeidel(A2, b2, x02, 1e-6, 50);


% =========================================================
% KASUS 3: Sistem 2x2 — tidak dominan diagonal
%    x1 + 4x2 = 5
%   4x1 +  x2 = 5
% =========================================================
fprintf('\n>>> KASUS 3: Sistem 2x2 (TIDAK dominan diagonal)\n');
fprintf('    x1 + 4x2 = 5\n');
fprintf('   4x1 +  x2 = 5\n\n');

A3  = [1 4;
       4 1];
b3  = [5; 5];
x03 = [0; 0];

[x3, tabel3, ok3] = gaussSeidel(A3, b3, x03, 1e-6, 20);


% =========================================================
% RINGKASAN SEMUA KASUS
% =========================================================
fprintf('*****************************************************\n');
fprintf('*   RINGKASAN SEMUA KASUS                          *\n');
fprintf('*****************************************************\n');
fprintf('  %-8s  %-8s  %-8s  %-16s  %s\n', ...
        'Kasus', 'Ukuran', 'Iterasi', 'Status', 'Solusi');
fprintf('  %s\n', repmat('-', 1, 70));

kasusInfo = {
    1, '3x3', tabel1, ok1, x1;
    2, '4x4', tabel2, ok2, x2;
    3, '2x2', tabel3, ok3, x3
};

for k = 1 : size(kasusInfo, 1)
    nKasus = kasusInfo{k, 1};
    ukuran = kasusInfo{k, 2};
    tbl    = kasusInfo{k, 3};
    isOk   = kasusInfo{k, 4};
    xHasil = kasusInfo{k, 5};

    if isempty(tbl)
        nIter = 0;
    else
        nIter = size(tbl, 1);
    end

    if isOk
        statusStr = 'KONVERGEN';
    else
        statusStr = 'TIDAK konvergen';
    end

    solStr = '';
    for vi = 1 : length(xHasil)
        if ~isnan(xHasil(vi))
            solStr = [solStr sprintf('x%d=%.4f ', vi, xHasil(vi))]; %#ok<AGROW>
        end
    end

    fprintf('  %-8d  %-8s  %-8d  %-16s  %s\n', ...
            nKasus, ukuran, nIter, statusStr, solStr);
end

fprintf('*****************************************************\n\n');
