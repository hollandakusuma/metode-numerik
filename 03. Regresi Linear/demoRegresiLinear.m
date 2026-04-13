% =========================================================
%  demoRegresiLinear  --  Contoh Kasus Teknik Elektro
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Isi demo:
%   Contoh 1 : Hukum Ohm  - hubungan V dan I
%   Contoh 2 : Sensor suhu - kalibrasi termistor
%   Contoh 3 : Daya vs tegangan pada beban resistif
%
%  CARA PAKAI:
%    Pastikan regresiLinear.m ada di folder yang sama,
%    lalu jalankan dengan F5.
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

clc; clear; close all;

%% ========================================================
%  CONTOH 1: Hukum Ohm
%  Eksperimen: ukur arus I pada berbagai tegangan V
%  Model: V = a0 + a1*I  --> a1 ≈ R (resistansi)
% =========================================================

fprintf('=== CONTOH 1: Hukum Ohm - Estimasi Resistansi ===\n\n');

% Data pengukuran (V, I)
I1 = [0.5  1.0  1.5  2.0  2.5  3.0  3.5  4.0];   % Ampere
V1 = [1.2  2.3  3.1  4.4  5.2  6.3  7.0  8.1];   % Volt

[a0_1, a1_1, hasil1] = regresiLinear(I1, V1);

fprintf('  Estimasi resistansi R = a1 = %.4f Ohm\n', a1_1);
fprintf('  Offset pengukuran a0  = %.4f V\n\n',      a0_1);

% --- Plot ---
figure(1);
set(gcf, 'Name', 'Contoh 1: Hukum Ohm');

iPlot  = linspace(0, 4.5, 100);
vFit   = a0_1 + a1_1 .* iPlot;

subplot(1, 2, 1);
plot(I1, V1, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');
hold on;
plot(iPlot, vFit, 'r-', 'LineWidth', 2);
hold off;
xlabel('Arus I (A)');
ylabel('Tegangan V (V)');
title('Regresi Linear - Hukum Ohm');
legend('Data ukur', sprintf('V = %.3f + %.3f*I  (R^2=%.4f)', ...
       a0_1, a1_1, hasil1.r2), 'Location', 'northwest');
grid on;

subplot(1, 2, 2);
bar(1:hasil1.n, hasil1.residu, 'FaceColor', [0.3 0.6 0.9]);
hold on;
plot([0 hasil1.n+1], [0 0], 'k-', 'LineWidth', 1);
hold off;
xlabel('Data ke-');
ylabel('Residu (V)');
title('Plot Residu');
grid on;

%% ========================================================
%  CONTOH 2: Kalibrasi Sensor Suhu (Termistor)
%  Data: tegangan output sensor vs suhu sebenarnya
%  Model: T = a0 + a1*Vout  --> konversi Volt ke Celsius
% =========================================================

fprintf('=== CONTOH 2: Kalibrasi Sensor Suhu ===\n\n');

Vout = [0.50  0.75  1.00  1.25  1.50  1.75  2.00  2.25  2.50];  % Volt
T    = [10.2  20.5  30.1  40.8  50.3  60.9  70.4  80.2  90.7];  % Celsius

[a0_2, a1_2, hasil2] = regresiLinear(Vout, T);

fprintf('  Persamaan kalibrasi: T = %.4f + %.4f * Vout\n', a0_2, a1_2);
fprintf('  Sensitivitas sensor : %.4f C/V\n',  a1_2);
fprintf('  r^2 = %.6f --> kualitas fit: %.2f%%\n\n', hasil2.r2, hasil2.r2*100);

% Contoh penggunaan: estimasi suhu dari tegangan terukur
VTest = 1.35;
TEstimasi = a0_2 + a1_2 * VTest;
fprintf('  Contoh: Vout = %.2f V --> T estimasi = %.2f C\n\n', VTest, TEstimasi);

% --- Plot ---
figure(2);
set(gcf, 'Name', 'Contoh 2: Kalibrasi Sensor Suhu');

vPlot = linspace(0.3, 2.7, 100);
tFit  = a0_2 + a1_2 .* vPlot;

subplot(1, 2, 1);
plot(Vout, T, 'rs', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
hold on;
plot(vPlot, tFit, 'b-', 'LineWidth', 2);
plot(VTest, TEstimasi, 'g^', 'MarkerSize', 10, 'MarkerFaceColor', 'g');
hold off;
xlabel('Tegangan Output Sensor (V)');
ylabel('Suhu (C)');
title('Kalibrasi Sensor Suhu');
legend('Data kalibrasi', ...
       sprintf('T = %.2f + %.2f*V', a0_2, a1_2), ...
       sprintf('Prediksi: %.2fV -> %.2fC', VTest, TEstimasi), ...
       'Location', 'northwest');
grid on;

subplot(1, 2, 2);
bar(1:hasil2.n, hasil2.residu, 'FaceColor', [0.9 0.4 0.4]);
hold on;
plot([0 hasil2.n+1], [0 0], 'k-', 'LineWidth', 1);
hold off;
xlabel('Data ke-');
ylabel('Residu (C)');
title('Plot Residu - Sensor Suhu');
grid on;

%% ========================================================
%  CONTOH 3: Daya vs Tegangan pada Beban Resistif
%  Hukum: P = V^2 / R
%  Jika kita plot P vs V^2, seharusnya linear
%  Model: P = a0 + a1*(V^2)  --> a1 ≈ 1/R
% =========================================================

fprintf('=== CONTOH 3: Daya vs Tegangan (Beban Resistif) ===\n\n');

V3 = [2.0   4.0   6.0   8.0   10.0  12.0  14.0  16.0];   % Volt
P3 = [0.42  1.65  3.72  6.60  10.25 14.88 20.28 25.90];  % Watt

V3sq = V3 .^ 2;   % transformasi: variabel bebas jadi V^2

[a0_3, a1_3, hasil3] = regresiLinear(V3sq, P3);

REstimasi = 1 / a1_3;
fprintf('  Model   : P = %.4f + %.6f * V^2\n', a0_3, a1_3);
fprintf('  Estimasi R = 1/a1 = %.4f Ohm\n',    REstimasi);
fprintf('  r^2 = %.6f\n\n', hasil3.r2);

% --- Plot ---
figure(3);
set(gcf, 'Name', 'Contoh 3: Daya vs Tegangan');

subplot(1, 2, 1);
v3Plot  = linspace(0, 17, 100);
pFit    = a0_3 + a1_3 .* v3Plot.^2;

plot(V3, P3, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
hold on;
plot(v3Plot, pFit, 'm-', 'LineWidth', 2);
hold off;
xlabel('Tegangan V (Volt)');
ylabel('Daya P (Watt)');
title('Daya vs Tegangan');
legend('Data ukur', ...
       sprintf('P = %.3f + %.4f*V^2  (R=%.2f Ohm)', a0_3, a1_3, REstimasi), ...
       'Location', 'northwest');
grid on;

subplot(1, 2, 2);
plot(V3sq, P3, 'ko', 'MarkerSize', 8, 'MarkerFaceColor', 'k');
hold on;
v3sqPlot = linspace(0, 270, 100);
plot(v3sqPlot, a0_3 + a1_3.*v3sqPlot, 'm-', 'LineWidth', 2);
hold off;
xlabel('V^2 (Volt^2)');
ylabel('Daya P (Watt)');
title('Linearisasi: P vs V^2');
legend('Data', sprintf('Fit linear (r^2=%.4f)', hasil3.r2), ...
       'Location', 'northwest');
grid on;

%% ========================================================
%  RINGKASAN
% =========================================================
fprintf('========================================================\n');
fprintf('              RINGKASAN HASIL REGRESI LINEAR\n');
fprintf('========================================================\n');
fprintf('  Contoh 1 (Hukum Ohm)   : R estimasi = %.4f Ohm\n',  a1_1);
fprintf('                           r^2 = %.6f\n',              hasil1.r2);
fprintf('  Contoh 2 (Sensor suhu) : %.4f C/V\n',               a1_2);
fprintf('                           r^2 = %.6f\n',              hasil2.r2);
fprintf('  Contoh 3 (Daya-V)      : R estimasi = %.4f Ohm\n',  REstimasi);
fprintf('                           r^2 = %.6f\n',              hasil3.r2);
fprintf('========================================================\n\n');
