% =========================================================
%  demoFixedPoint.m
%  Program Demo: Metode Fixed Point Iteration
%  Kompatibel dengan MATLAB R2015a/b
%
%  Jalankan file ini untuk melihat contoh penggunaan
%  fungsi fixedPointIteration pada beberapa kasus.
% =========================================================

clc;
clear;
close all;

fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*   DEMO PROGRAM: FIXED POINT ITERATION            *\n');
fprintf('*****************************************************\n\n');

% =========================================================
% KASUS 1: Mencari akar dari f(x) = x^2 - x - 2 = 0
%          Bentuk g(x): x = sqrt(x + 2)   -> hasilnya x = 2
% =========================================================
fprintf('>>> KASUS 1: f(x) = x^2 - x - 2 = 0\n');
fprintf('    Transformasi: x = sqrt(x + 2)\n\n');

gFungsi1 = @(x) sqrt(x + 2);
x0_1     = 1.5;
toleransi = 1e-8;
maxIterasi = 50;

[solusi1, tabel1, konvergen1] = fixedPointIteration(gFungsi1, x0_1, toleransi, maxIterasi);

plotKonvergensi(tabel1, 'Kasus 1: x = sqrt(x+2)', konvergen1, gFungsi1);


% =========================================================
% KASUS 2: Mencari akar dari f(x) = x^3 - x - 1 = 0
%          Bentuk g(x): x = (x + 1)^(1/3)  -> akar ~1.3247
% =========================================================
fprintf('>>> KASUS 2: f(x) = x^3 - x - 1 = 0\n');
fprintf('    Transformasi: x = (x + 1)^(1/3)\n\n');

gFungsi2 = @(x) (x + 1)^(1/3);
x0_2     = 1.0;

[solusi2, tabel2, konvergen2] = fixedPointIteration(gFungsi2, x0_2, toleransi, maxIterasi);

plotKonvergensi(tabel2, 'Kasus 2: x = (x+1)^(1/3)', konvergen2, gFungsi2);


% =========================================================
% KASUS 3: Persamaan cos(x) = x  ->  g(x) = cos(x)
%          Titik tetap (fixed point) ~0.7391
% =========================================================
fprintf('>>> KASUS 3: cos(x) = x  ->  g(x) = cos(x)\n\n');

gFungsi3 = @(x) cos(x);
x0_3     = 0.5;

[solusi3, tabel3, konvergen3] = fixedPointIteration(gFungsi3, x0_3, toleransi, 200);

plotKonvergensi(tabel3, 'Kasus 3: x = cos(x)', konvergen3, gFungsi3);


% =========================================================
% KASUS 4: Contoh TIDAK KONVERGEN
%          g(x) = x^2 - 1  (divergen dari x0 = 1.5)
% =========================================================
fprintf('>>> KASUS 4 (Divergen): g(x) = x^2 - 1, x0 = 1.5\n\n');

gFungsi4 = @(x) x^2 - 1;
x0_4     = 1.5;

[solusi4, tabel4, konvergen4] = fixedPointIteration(gFungsi4, x0_4, 1e-8, 15);


% =========================================================
% RINGKASAN HASIL
% =========================================================
fprintf('\n');
fprintf('*****************************************************\n');
fprintf('*   RINGKASAN HASIL SEMUA KASUS                    *\n');
fprintf('*****************************************************\n');
fprintf('  %-8s  %-30s  %-15s  %-10s\n', 'Kasus', 'g(x)', 'Solusi', 'Status');
fprintf('  %s\n', repmat('-', 1, 68));
fprintf('  %-8s  %-30s  %-15.8f  %-10s\n', '1', 'x = sqrt(x+2)',    solusi1, statusStr(konvergen1));
fprintf('  %-8s  %-30s  %-15.8f  %-10s\n', '2', 'x = (x+1)^(1/3)',  solusi2, statusStr(konvergen2));
fprintf('  %-8s  %-30s  %-15.8f  %-10s\n', '3', 'x = cos(x)',       solusi3, statusStr(konvergen3));
fprintf('  %-8s  %-30s  %-15.8f  %-10s\n', '4', 'x = x^2 - 1',     solusi4, statusStr(konvergen4));
fprintf('*****************************************************\n\n');
