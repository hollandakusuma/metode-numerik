% =========================================================
%  DEMO REGULA FALSI  --  Contoh Kasus Teknik Elektro
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Isi demo:
%   Contoh 1 : Rangkaian RC   - waktu discharge ke 20% Vs
%   Contoh 2 : Dioda Shockley - Q-point
%   Contoh 3 : Perbandingan Biseksi vs Regula Falsi
%
%  CARA PAKAI:
%    Pastikan bisection.m dan regulaFalsi.m ada di folder
%    yang sama, lalu jalankan dengan F5.
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

clc; clear; close all;

%% ========================================================
%  CONTOH 1: Rangkaian RC - Waktu Discharge
%  Kapasitor discharge: Vc(t) = Vs * exp(-t/RC)
%  Cari t ketika Vc = 0.2 * Vs
%
%  f(t) = exp(-t/RC) - 0.2 = 0
% =========================================================

fprintf('=== CONTOH 1: Discharge Kapasitor RC ===\n');
fprintf('Cari waktu t ketika Vc turun ke 20%% dari Vs\n\n');

R  = 2200;       % Ohm  (2.2 kohm)
C  = 470e-6;     % Farad (470 uF)
RC = R * C;

f1 = @(t) exp(-t ./ RC) - 0.2;

[t_akar, tabel1] = regulaFalsi(f1, 0.1, 10.0, 1e-8, 100);

fprintf('  RC (tau)          = %.4f detik\n', RC);
fprintf('  Vc=20%% Vs saat t  = %.6f detik\n', t_akar);
fprintf('  Analitik: RC*ln(5) = %.6f detik\n\n', RC * log(5));

% --- Plot ---
figure(1);
set(gcf, 'Name', 'Contoh 1: Discharge RC');

t_plot  = linspace(0, 10, 500);
Vc_norm = exp(-t_plot ./ RC);

subplot(1, 2, 1);
plot(t_plot, Vc_norm, 'b-', 'LineWidth', 2);
hold on;
plot([0 10],          [0.2 0.2],          'r--', 'LineWidth', 1.5);
plot([t_akar t_akar], [0 1],              'g--', 'LineWidth', 1.5);
plot(t_akar, 0.2, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
xlabel('Waktu (s)');
ylabel('Vc / Vs');
title('Discharge Kapasitor RC');
legend('Vc(t)/Vs', '20% Vs', sprintf('t = %.4f s', t_akar), 'Titik akar', ...
       'Location', 'northeast');
grid on;

subplot(1, 2, 2);
semilogy(tabel1(:,1), tabel1(:,6), 'bs-', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Regula Falsi - RC');
grid on;

%% ========================================================
%  CONTOH 2: Dioda Zener - Titik Regulasi
%  Model sederhana: Id = Is*(exp(Vd/Vt) - 1)
%  Tegangan sumber Vs = 9V, R = 470 Ohm
%  f(Vd) = Is*(exp(Vd/Vt)-1)*R + Vd - Vs = 0
% =========================================================

fprintf('=== CONTOH 2: Rangkaian Dioda (Vs=9V, R=470 Ohm) ===\n');
fprintf('Cari Q-point: Vd dan Id\n\n');

Vs2 = 9.0;       % Volt
R2  = 470;       % Ohm
Is  = 1e-12;     % Ampere
Vt  = 0.02585;   % Volt

f2 = @(Vd) Is .* (exp(Vd ./ Vt) - 1) .* R2 + Vd - Vs2;

[Vd_akar, tabel2] = regulaFalsi(f2, 0.0, 1.0, 1e-8, 100);
Id_akar = Is * (exp(Vd_akar / Vt) - 1);

fprintf('  Tegangan dioda : Vd = %.6f V\n',   Vd_akar);
fprintf('  Arus dioda     : Id = %.4f mA\n',  Id_akar * 1000);
fprintf('  Drop resistor  : Vr = %.4f V\n',   Id_akar * R2);
fprintf('  Cek KVL        : %.6f V (Vs = %.1f V)\n\n', ...
        Vd_akar + Id_akar * R2, Vs2);

% --- Plot ---
figure(2);
set(gcf, 'Name', 'Contoh 2: Q-point Dioda');

Vd_plot  = linspace(0.01, 0.85, 500);
Id_dioda = Is .* (exp(Vd_plot ./ Vt) - 1);
Id_load  = (Vs2 - Vd_plot) ./ R2;

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
ylim([0 (Vs2/R2)*1000*1.1]);
grid on;

subplot(1, 2, 2);
semilogy(tabel2(:,1), tabel2(:,6), 'rs-', 'LineWidth', 1.5, 'MarkerSize', 6);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Regula Falsi - Dioda');
grid on;

%% ========================================================
%  CONTOH 3: PERBANDINGAN Biseksi vs Regula Falsi
%  Fungsi uji: f(x) = x^3 - x - 2
%  Interval  : [1, 2]   -->  akar di x = 1.5214...
% =========================================================

fprintf('=== CONTOH 3: Perbandingan Biseksi vs Regula Falsi ===\n');
fprintf('Fungsi: f(x) = x^3 - x - 2,  interval [1, 2]\n\n');

f3 = @(x) x.^3 - x - 2;
a3 = 1;  b3 = 2;

[akar_bis, tabel_bis] = bisection(f3,     a3, b3, 1e-8, 100);
[akar_rf,  tabel_rf]  = regulaFalsi(f3,  a3, b3, 1e-8, 100);

fprintf('  Akar (Biseksi)      : x = %.10f  (%d iterasi)\n', ...
        akar_bis, size(tabel_bis, 1));
fprintf('  Akar (Regula Falsi) : x = %.10f  (%d iterasi)\n', ...
        akar_rf,  size(tabel_rf,  1));
fprintf('  Selisih hasil       : %.4e\n\n', abs(akar_bis - akar_rf));

% --- Plot perbandingan konvergensi ---
figure(3);
set(gcf, 'Name', 'Contoh 3: Perbandingan Biseksi vs Regula Falsi');

subplot(1, 2, 1);
x_plot = linspace(0.5, 2.5, 400);
y_plot = f3(x_plot);
plot(x_plot, y_plot, 'b-', 'LineWidth', 2);
hold on;
plot([x_plot(1) x_plot(end)], [0 0], 'k--', 'LineWidth', 1);
plot(akar_bis, 0, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
xlabel('x');
ylabel('f(x)');
title('f(x) = x^3 - x - 2');
legend('f(x)', 'y = 0', sprintf('Akar = %.6f', akar_bis));
grid on;

subplot(1, 2, 2);
semilogy(tabel_bis(:,1), tabel_bis(:,6), 'bo-', 'LineWidth', 2, 'MarkerSize', 6);
hold on;
semilogy(tabel_rf(:,1),  tabel_rf(:,6),  'rs-', 'LineWidth', 2, 'MarkerSize', 6);
hold off;
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Perbandingan Konvergensi');
legend(sprintf('Biseksi (%d iter)', size(tabel_bis,1)), ...
       sprintf('Regula Falsi (%d iter)', size(tabel_rf,1)), ...
       'Location', 'northeast');
grid on;

%% ========================================================
%  RINGKASAN HASIL
% =========================================================
fprintf('========================================================\n');
fprintf('            RINGKASAN HASIL REGULA FALSI\n');
fprintf('========================================================\n');
fprintf('  Contoh 1 (RC discharge) : t  = %.6f detik\n', t_akar);
fprintf('  Contoh 2 (Dioda 9V)     : Vd = %.6f V\n',     Vd_akar);
fprintf('  Contoh 3 - Biseksi      : x  = %.8f (%d iter)\n', akar_bis, size(tabel_bis,1));
fprintf('  Contoh 3 - Regula Falsi : x  = %.8f (%d iter)\n', akar_rf,  size(tabel_rf,1));
fprintf('========================================================\n\n');
