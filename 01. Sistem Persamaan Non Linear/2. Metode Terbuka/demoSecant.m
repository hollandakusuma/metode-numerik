% =========================================================
%  demoSecant  --  Contoh Kasus Teknik Elektro
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Isi demo:
%   Contoh 1 : Rangkaian RLC  - frekuensi resonansi
%   Contoh 2 : Dioda Shockley - Q-point
%   Contoh 3 : Perbandingan 4 metode sekaligus
%
%  CARA PAKAI:
%    Pastikan file berikut ada di folder yang sama:
%      bisection.m, regulaFalsi.m, newtonRaphson.m, secantMethod.m
%    lalu jalankan dengan F5.
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

clc; clear; close all;

%% ========================================================
%  CONTOH 1: Rangkaian RLC Seri - Frekuensi Resonansi
%  Im(Z) = wL - 1/(wC) = 0
%  f(w)  = wL - 1/(wC)
%  Tanpa turunan -- cocok untuk secant
% =========================================================

fprintf('=== CONTOH 1: Resonansi RLC Seri ===\n');
fprintf('Cari frekuensi angular resonansi w0 (rad/s)\n\n');

L1 = 10e-3;     % Henry  (10 mH)
C1 = 100e-6;    % Farad  (100 uF)
R1 = 10;        % Ohm

f1 = @(w) w .* L1 - 1 ./ (w .* C1);

x0_1 = 800;     % tebakan awal pertama
x1_1 = 1200;    % tebakan awal kedua

[w0, iterTable1] = secantMethod(f1, x0_1, x1_1, 1e-8, 50);
f0hz = w0 / (2 * pi);

fprintf('  Frekuensi angular  : w0 = %.4f rad/s\n', w0);
fprintf('  Frekuensi resonansi: f0 = %.4f Hz\n',    f0hz);
fprintf('  Analitik: 1/sqrt(LC) = %.4f rad/s\n\n',  1/sqrt(L1*C1));

% --- Plot ---
figure(1);
set(gcf, 'Name', 'Contoh 1: Resonansi RLC');

wPlot = linspace(100, 5000, 1000);
Xnet  = wPlot .* L1 - 1 ./ (wPlot .* C1);
Zmag  = sqrt(R1^2 + Xnet.^2);

subplot(1, 2, 1);
[ax, h1, h2] = plotyy(wPlot, Xnet, wPlot, Zmag);
set(h1, 'LineWidth', 2, 'Color', 'b');
set(h2, 'LineWidth', 2, 'Color', 'r');
hold(ax(1), 'on');
plot(ax(1), [w0 w0],       [-200 200], 'g--', 'LineWidth', 1.5);
plot(ax(1), [100 5000],    [0 0],      'k--', 'LineWidth', 1);
hold(ax(1), 'off');
ylabel(ax(1), 'Reaktansi Net (Ohm)');
ylabel(ax(2), '|Z| (Ohm)');
xlabel('omega (rad/s)');
title('Impedansi RLC vs Frekuensi');
legend([h1 h2], {'Im(Z)', '|Z|'}, 'Location', 'northeast');
grid(ax(1), 'on');

subplot(1, 2, 2);
semilogy(iterTable1(:,1), iterTable1(:,6), 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Secant - RLC');
grid on;

%% ========================================================
%  CONTOH 2: Dioda Shockley - Q-point
%  f(Vd) = Is*(exp(Vd/Vt)-1)*R + Vd - Vs
%  Tanpa turunan -- gunakan dua tebakan awal
% =========================================================

fprintf('=== CONTOH 2: Dioda Shockley - Q-point ===\n\n');

Vs = 5.0;
R2 = 1000;
Is = 1e-12;
Vt = 0.02585;

f2 = @(Vd) Is .* (exp(Vd ./ Vt) - 1) .* R2 + Vd - Vs;

x0_2 = 0.5;
x1_2 = 0.8;

[VdAkar, iterTable2] = secantMethod(f2, x0_2, x1_2, 1e-8, 50);
IdAkar = Is * (exp(VdAkar / Vt) - 1);

fprintf('  Tegangan dioda : Vd = %.6f V\n',   VdAkar);
fprintf('  Arus dioda     : Id = %.4f mA\n',  IdAkar * 1000);
fprintf('  Drop resistor  : Vr = %.4f V\n',   IdAkar * R2);
fprintf('  Cek KVL        : %.6f V (Vs = %.1f V)\n\n', ...
        VdAkar + IdAkar * R2, Vs);

figure(2);
set(gcf, 'Name', 'Contoh 2: Q-point Dioda');

VdPlot  = linspace(0.01, 0.85, 500);
IdDioda = Is .* (exp(VdPlot ./ Vt) - 1);
IdLoad  = (Vs - VdPlot) ./ R2;

subplot(1, 2, 1);
plot(VdPlot, IdDioda .* 1000, 'b-', 'LineWidth', 2);
hold on;
plot(VdPlot, IdLoad  .* 1000, 'r-', 'LineWidth', 2);
plot(VdAkar, IdAkar  .* 1000, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
hold off;
xlabel('Vd (V)'); ylabel('Id (mA)');
title('Load Line Dioda');
legend('Kurva Dioda', 'Garis Beban', ...
       sprintf('Q: %.3fV, %.3fmA', VdAkar, IdAkar*1000), ...
       'Location', 'northwest');
xlim([0 0.9]); ylim([0 (Vs/R2)*1000*1.1]);
grid on;

subplot(1, 2, 2);
semilogy(iterTable2(:,1), iterTable2(:,6), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Iterasi'); ylabel('Error Relatif (%)');
title('Konvergensi Secant - Dioda');
grid on;

%% ========================================================
%  CONTOH 3: PERBANDINGAN 4 METODE
%  f(x) = x^3 - x - 2,  akar sejati x = 1.52137971...
%
%  Metode tertutup : bisection, regulaFalsi  --> interval [1,2]
%  Metode terbuka  : newtonRaphson, secant   --> tebakan x0=1.5
% =========================================================

fprintf('=== CONTOH 3: Perbandingan 4 Metode ===\n');
fprintf('f(x) = x^3 - x - 2\n\n');

f3  = @(x) x.^3 - x - 2;
df3 = @(x) 3.*x.^2 - 1;

[akarBis, tabelBis] = bisection(f3,              1,   2,   1e-8, 100);
[akarRF,  tabelRF]  = regulaFalsi(f3,            1,   2,   1e-8, 100);
[akarNR,  tabelNR]  = newtonRaphson(f3, df3,     1.5, 1e-8, 100);
[akarSec, tabelSec] = secantMethod(f3,       1.5, 2.0, 1e-8, 100);

fprintf('  Biseksi          : x = %.10f  (%2d iterasi)\n', akarBis, size(tabelBis,1));
fprintf('  Regula Falsi     : x = %.10f  (%2d iterasi)\n', akarRF,  size(tabelRF,1));
fprintf('  Newton-Raphson   : x = %.10f  (%2d iterasi)\n', akarNR,  size(tabelNR,1));
fprintf('  Secant           : x = %.10f  (%2d iterasi)\n', akarSec, size(tabelSec,1));

figure(3);
set(gcf, 'Name', 'Contoh 3: Perbandingan 4 Metode');

subplot(1, 2, 1);
xPlot = linspace(0.5, 2.5, 400);
yPlot = f3(xPlot);
plot(xPlot, yPlot, 'b-', 'LineWidth', 2);
hold on;
plot([xPlot(1) xPlot(end)], [0 0], 'k--');
plot(akarSec, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
xlabel('x'); ylabel('f(x)');
title('f(x) = x^3 - x - 2');
legend('f(x)', 'y = 0', sprintf('Akar = %.6f', akarSec));
grid on;

subplot(1, 2, 2);
semilogy(tabelBis(:,1), tabelBis(:,6), 'b^-',  'LineWidth', 2, 'MarkerSize', 6);
hold on;
semilogy(tabelRF(:,1),  tabelRF(:,6),  'gs-',  'LineWidth', 2, 'MarkerSize', 6);
semilogy(tabelNR(:,1),  tabelNR(:,6),  'rd-',  'LineWidth', 2, 'MarkerSize', 8);
semilogy(tabelSec(:,1), tabelSec(:,6), 'ko-',  'LineWidth', 2, 'MarkerSize', 8);
hold off;
xlabel('Iterasi'); ylabel('Error Relatif (%)');
title('Perbandingan Konvergensi 4 Metode');
legend(sprintf('Biseksi        (%d iter)', size(tabelBis,1)), ...
       sprintf('Regula Falsi   (%d iter)', size(tabelRF,1)),  ...
       sprintf('Newton-Raphson (%d iter)', size(tabelNR,1)),  ...
       sprintf('Secant         (%d iter)', size(tabelSec,1)), ...
       'Location', 'northeast');
grid on;

%% ========================================================
%  RINGKASAN
% =========================================================
fprintf('\n========================================================\n');
fprintf('                   RINGKASAN HASIL\n');
fprintf('========================================================\n');
fprintf('  Contoh 1 (RLC)   : w0 = %.4f rad/s\n', w0);
fprintf('  Contoh 2 (Dioda) : Vd = %.6f V\n',     VdAkar);
fprintf('  Contoh 3 - Biseksi        : %2d iterasi\n', size(tabelBis,1));
fprintf('  Contoh 3 - Regula Falsi   : %2d iterasi\n', size(tabelRF,1));
fprintf('  Contoh 3 - Newton-Raphson : %2d iterasi\n', size(tabelNR,1));
fprintf('  Contoh 3 - Secant         : %2d iterasi\n', size(tabelSec,1));
fprintf('========================================================\n\n');
