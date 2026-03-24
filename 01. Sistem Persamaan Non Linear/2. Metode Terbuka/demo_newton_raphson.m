% =========================================================
%  DEMO NEWTON-RAPHSON  --  Contoh Kasus Teknik Elektro
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Isi demo:
%   Contoh 1 : Rangkaian RL   - arus steady state
%   Contoh 2 : Dioda Shockley - Q-point
%   Contoh 3 : Perbandingan konvergensi vs Biseksi & Regula Falsi
%
%  CARA PAKAI:
%    Pastikan newton_raphson.m, bisection.m, regula_falsi.m
%    ada di folder yang sama, lalu jalankan dengan F5.
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

clc; clear; close all;

%% ========================================================
%  CONTOH 1: Rangkaian RL Seri - Cari Frekuensi Cut-off
%  Pada filter RL, frekuensi cut-off saat:
%  |H(jw)| = 1/sqrt(2)  --> gain turun 3dB
%
%  |H| = R / sqrt(R^2 + (wL)^2) = 1/sqrt(2)
%
%  Kuadratkan dan susun ulang:
%  f(w) = R^2 + (wL)^2 - 2*R^2 = (wL)^2 - R^2 = 0
%  f'(w) = 2*w*L^2
% =========================================================

fprintf('=== CONTOH 1: Filter RL - Frekuensi Cut-off (-3dB) ===\n');
fprintf('Cari frekuensi angular cut-off wc\n\n');

R1 = 1000;      % Ohm  (1 kohm)
L1 = 0.5;       % Henry (500 mH)

% f(w)  = (wL)^2 - R^2
% f'(w) = 2*w*L^2
f1  = @(w) (w .* L1).^2 - R1^2;
df1 = @(w) 2 .* w .* L1^2;

x0_1 = 1500;    % tebakan awal (rad/s)

[wc, tabel1] = newtonRaphson(f1, df1, x0_1, 1e-8, 50);
fc_hz = wc / (2 * pi);

fprintf('  Frekuensi cut-off : wc = %.4f rad/s\n', wc);
fprintf('  Frekuensi cut-off : fc = %.4f Hz\n',    fc_hz);
fprintf('  Analitik: R/L     = %.4f rad/s\n\n',    R1/L1);

% --- Plot respons frekuensi ---
figure(1);
set(gcf, 'Name', 'Contoh 1: Filter RL');

w_plot = linspace(100, 5000, 1000);
H_mag  = R1 ./ sqrt(R1^2 + (w_plot .* L1).^2);

subplot(1, 2, 1);
semilogx(w_plot, 20*log10(H_mag), 'b-', 'LineWidth', 2);
hold on;
plot([wc wc],    [-40 0],         'r--', 'LineWidth', 1.5);
plot([100 5000], [-3 -3],         'g--', 'LineWidth', 1.5);
plot(wc, -3, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
xlabel('omega (rad/s)');
ylabel('|H| (dB)');
title('Respons Frekuensi Filter RL');
legend('|H(jw)|', sprintf('wc = %.1f', wc), '-3 dB', 'Titik cut-off', ...
       'Location', 'southwest');
grid on;

subplot(1, 2, 2);
semilogy(tabel1(:,1), tabel1(:,6), 'bo-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Newton-Raphson');
grid on;

%% ========================================================
%  CONTOH 2: Dioda Shockley - Q-point
%  (kasus sama dengan demo sebelumnya, bandingkan iterasi)
%
%  f(Vd)  = Is*(exp(Vd/Vt)-1)*R + Vd - Vs
%  f'(Vd) = Is*(1/Vt)*exp(Vd/Vt)*R + 1
% =========================================================

fprintf('=== CONTOH 2: Dioda Shockley - Q-point ===\n');
fprintf('Cari Vd dan Id (bandingkan jumlah iterasi dengan metode sebelumnya)\n\n');

Vs = 5.0;
R2 = 1000;
Is = 1e-12;
Vt = 0.02585;

f2  = @(Vd) Is .* (exp(Vd ./ Vt) - 1) .* R2 + Vd - Vs;
df2 = @(Vd) Is .* (1./Vt) .* exp(Vd ./ Vt) .* R2 + 1;

x0_2 = 0.7;     % tebakan awal (Volt) -- dekat tegangan maju dioda Si

[Vd_akar, tabel2] = newtonRaphson(f2, df2, x0_2, 1e-8, 50);
Id_akar = Is * (exp(Vd_akar / Vt) - 1);

fprintf('  Tegangan dioda : Vd = %.6f V\n',   Vd_akar);
fprintf('  Arus dioda     : Id = %.4f mA\n',  Id_akar * 1000);
fprintf('  Drop resistor  : Vr = %.4f V\n',   Id_akar * R2);
fprintf('  Cek KVL        : %.6f V (Vs = %.1f V)\n\n', ...
        Vd_akar + Id_akar * R2, Vs);

% --- Plot ---
figure(2);
set(gcf, 'Name', 'Contoh 2: Q-point Dioda');

Vd_plot  = linspace(0.01, 0.85, 500);
Id_dioda = Is .* (exp(Vd_plot ./ Vt) - 1);
Id_load  = (Vs - Vd_plot) ./ R2;

subplot(1, 2, 1);
plot(Vd_plot, Id_dioda .* 1000, 'b-', 'LineWidth', 2);
hold on;
plot(Vd_plot, Id_load  .* 1000, 'r-', 'LineWidth', 2);
plot(Vd_akar, Id_akar  .* 1000, 'ko', 'MarkerSize', 10, 'MarkerFaceColor', 'k');
hold off;
xlabel('Vd (V)');
ylabel('Id (mA)');
title('Load Line Dioda');
legend('Kurva Dioda', 'Garis Beban', ...
       sprintf('Q: %.3fV, %.3fmA', Vd_akar, Id_akar*1000), ...
       'Location', 'northwest');
xlim([0 0.9]);
ylim([0 (Vs/R2)*1000*1.1]);
grid on;

subplot(1, 2, 2);
semilogy(tabel2(:,1), tabel2(:,6), 'ro-', 'LineWidth', 2, 'MarkerSize', 8);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Newton-Raphson - Dioda');
grid on;

%% ========================================================
%  CONTOH 3: PERBANDINGAN 3 Metode
%  Fungsi uji: f(x) = x^3 - x - 2
%  Biseksi & Regula Falsi : interval [1, 2]
%  Newton-Raphson         : tebakan awal x0 = 1.5
% =========================================================

fprintf('=== CONTOH 3: Perbandingan Biseksi vs Regula Falsi vs Newton-Raphson ===\n');
fprintf('Fungsi: f(x) = x^3 - x - 2\n\n');

f3  = @(x) x.^3 - x - 2;
df3 = @(x) 3.*x.^2 - 1;

[akar_bis, tabel_bis] = bisection(f3,          1,   2,   1e-8, 100);
[akar_rf,  tabel_rf]  = regulaFalsi(f3,       1,   2,   1e-8, 100);
[akar_nr,  tabel_nr]  = newtonRaphson(f3, df3, 1.5, 1e-8, 100);

fprintf('  Biseksi         : x = %.10f  (%2d iterasi)\n', akar_bis, size(tabel_bis,1));
fprintf('  Regula Falsi    : x = %.10f  (%2d iterasi)\n', akar_rf,  size(tabel_rf,1));
fprintf('  Newton-Raphson  : x = %.10f  (%2d iterasi)\n', akar_nr,  size(tabel_nr,1));

% --- Plot perbandingan konvergensi ---
figure(3);
set(gcf, 'Name', 'Contoh 3: Perbandingan 3 Metode');

subplot(1, 2, 1);
x_plot = linspace(0.5, 2.5, 400);
y_plot = f3(x_plot);
plot(x_plot, y_plot, 'b-', 'LineWidth', 2);
hold on;
plot([x_plot(1) x_plot(end)], [0 0], 'k--', 'LineWidth', 1);
plot(akar_nr, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
xlabel('x'); ylabel('f(x)');
title('f(x) = x^3 - x - 2');
legend('f(x)', 'y = 0', sprintf('Akar = %.6f', akar_nr));
grid on;

subplot(1, 2, 2);
semilogy(tabel_bis(:,1), tabel_bis(:,6), 'bo-',  'LineWidth', 2, 'MarkerSize', 6);
hold on;
semilogy(tabel_rf(:,1),  tabel_rf(:,6),  'gs-',  'LineWidth', 2, 'MarkerSize', 6);
semilogy(tabel_nr(:,1),  tabel_nr(:,6),  'rd-',  'LineWidth', 2, 'MarkerSize', 8);
hold off;
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Perbandingan Konvergensi');
legend(sprintf('Biseksi       (%d iter)', size(tabel_bis,1)), ...
       sprintf('Regula Falsi  (%d iter)', size(tabel_rf,1)),  ...
       sprintf('Newton-Raphson (%d iter)', size(tabel_nr,1)), ...
       'Location', 'northeast');
grid on;

%% ========================================================
%  RINGKASAN
% =========================================================
fprintf('\n========================================================\n');
fprintf('              RINGKASAN HASIL\n');
fprintf('========================================================\n');
fprintf('  Contoh 1 (Filter RL) : wc = %.4f rad/s\n', wc);
fprintf('  Contoh 2 (Dioda)     : Vd = %.6f V\n',     Vd_akar);
fprintf('  Contoh 3 - Biseksi        : %2d iterasi\n', size(tabel_bis,1));
fprintf('  Contoh 3 - Regula Falsi   : %2d iterasi\n', size(tabel_rf,1));
fprintf('  Contoh 3 - Newton-Raphson : %2d iterasi\n', size(tabel_nr,1));
fprintf('========================================================\n\n');
