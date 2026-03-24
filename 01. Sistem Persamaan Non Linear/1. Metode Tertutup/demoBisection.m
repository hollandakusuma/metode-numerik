% =========================================================
%  DEMO BISEKSI  --  Contoh Kasus Teknik Elektro
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Tiga contoh aplikasi metode biseksi:
%
%   Contoh 1 : Rangkaian RC   - mencari waktu t saat Vc = 50% Vs
%   Contoh 2 : Dioda Shockley - titik kerja Q-point
%   Contoh 3 : Rangkaian RLC  - frekuensi resonansi
%
%  CARA PAKAI:
%    Pastikan file bisection.m ada di folder yang sama,
%    lalu jalankan script ini dengan F5 atau klik Run.
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

clc; clear; close all;

%% ========================================================
%  CONTOH 1: Rangkaian RC
%  Mencari waktu t ketika Vc(t) = 0.5 * Vs
%
%  Vc(t) = Vs * (1 - exp(-t/RC))
%  Persamaan: exp(-t/RC) - 0.5 = 0
% =========================================================

fprintf('=== CONTOH 1: Rangkaian RC ===\n');
fprintf('Kapan Vc mencapai 50%% dari Vs?\n\n');

R  = 1000;       % Ohm  (1 kohm)
C  = 1e-3;       % Farad (1 mF)
RC = R * C;      % konstanta waktu tau = 1 detik

f1 = @(t) exp(-t ./ RC) - 0.5;

[t_akar, tabel1] = bisection(f1, 0.1, 5.0, 1e-8, 100);

fprintf('  RC (tau)  = %.4f detik\n', RC);
fprintf('  Vc=50%%Vs saat t = %.6f detik\n', t_akar);
fprintf('  Analitik: t = RC*ln(2) = %.6f detik\n\n', RC * log(2));

% --- Plot Contoh 1 ---
figure(1);
set(gcf, 'Name', 'Contoh 1: Rangkaian RC');

t_plot  = linspace(0, 5, 500);
Vc_norm = 1 - exp(-t_plot ./ RC);

subplot(1, 2, 1);
plot(t_plot, Vc_norm, 'b-', 'LineWidth', 2);
hold on;
% ganti yline/xline dengan plot biasa (kompatibel MATLAB 2015)
plot([0 5],      [0.5 0.5],       'r--', 'LineWidth', 1.5);
plot([t_akar t_akar], [0 1],      'g--', 'LineWidth', 1.5);
plot(t_akar, 0.5, 'ro', 'MarkerSize', 10, 'MarkerFaceColor', 'r');
hold off;
xlabel('Waktu (s)');
ylabel('Vc / Vs');
title('Tegangan Kapasitor RC');
legend('Vc(t)/Vs', '50% Vs', sprintf('t = %.4f s', t_akar), 'Q-point', ...
       'Location', 'southeast');
grid on;

subplot(1, 2, 2);
semilogy(tabel1(:,1), tabel1(:,6), 'bo-', 'LineWidth', 1.5, 'MarkerSize', 5);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Biseksi - RC');
grid on;

%% ========================================================
%  CONTOH 2: Karakteristik Dioda (Model Shockley)
%  Rangkaian seri: Vs - R - Dioda
%
%  KVL  : Vs = Vd + Id*R
%  Dioda: Id = Is * (exp(Vd/Vt) - 1)
%
%  Substitusi -> f(Vd) = Is*(exp(Vd/Vt)-1)*R + Vd - Vs = 0
% =========================================================

fprintf('=== CONTOH 2: Dioda (Model Shockley) ===\n');
fprintf('Cari tegangan Vd dan arus Id (Q-point)\n\n');

Vs = 5.0;       % Volt  (sumber tegangan)
R2 = 1000;      % Ohm   (resistor seri)
Is = 1e-12;     % Ampere (arus saturasi balik)
Vt = 0.02585;   % Volt  (tegangan thermal, ~26 mV suhu kamar)

f2 = @(Vd) Is .* (exp(Vd ./ Vt) - 1) .* R2 + Vd - Vs;

[Vd_akar, tabel2] = bisection(f2, 0.0, 1.0, 1e-8, 100);
Id_akar = Is * (exp(Vd_akar / Vt) - 1);

fprintf('  Tegangan dioda : Vd = %.6f V\n',    Vd_akar);
fprintf('  Arus dioda     : Id = %.4f mA\n',   Id_akar * 1000);
fprintf('  Drop resistor  : Vr = %.6f V\n',    Id_akar * R2);
fprintf('  Cek KVL        : Vd+Id*R = %.6f V (Vs=%.1fV)\n\n', ...
        Vd_akar + Id_akar * R2, Vs);

% --- Plot Contoh 2 ---
figure(2);
set(gcf, 'Name', 'Contoh 2: Dioda Shockley');

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
legend('Kurva Dioda (Shockley)', 'Garis Beban', ...
       sprintf('Q: Vd=%.3fV, Id=%.3fmA', Vd_akar, Id_akar*1000), ...
       'Location', 'northwest');
xlim([0 0.9]);
ylim([0 (Vs / R2) * 1000 * 1.1]);
grid on;

subplot(1, 2, 2);
semilogy(tabel2(:,1), tabel2(:,6), 'ro-', 'LineWidth', 1.5, 'MarkerSize', 5);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Biseksi - Dioda');
grid on;

%% ========================================================
%  CONTOH 3: Rangkaian RLC Seri - Resonansi
%  Pada resonansi: reaktansi net = 0
%
%  Im(Z) = wL - 1/(wC) = 0
%  f(w)  = wL - 1/(wC)   --> cari w (rad/s)
% =========================================================

fprintf('=== CONTOH 3: Resonansi RLC Seri ===\n');
fprintf('Cari frekuensi angular resonansi omega0 (rad/s)\n');

L3 = 10e-3;      % Henry  (10 mH)
C3 = 100e-6;     % Farad  (100 uF)
R3 = 10;         % Ohm

f3 = @(w) w .* L3 - 1 ./ (w .* C3);

[w_akar, tabel3] = bisection(f3, 100, 5000, 1e-6, 100);
f_res = w_akar / (2 * pi);

fprintf('  Frekuensi angular  : w0 = %.4f rad/s\n', w_akar);
fprintf('  Frekuensi resonansi: f0 = %.4f Hz\n',    f_res);
fprintf('  Analitik: 1/sqrt(LC) = %.4f rad/s\n\n',  1/sqrt(L3*C3));

% --- Plot Contoh 3 ---
figure(3);
set(gcf, 'Name', 'Contoh 3: Resonansi RLC');

w_plot = linspace(100, 5000, 1000);
Xnet   = w_plot .* L3 - 1 ./ (w_plot .* C3);
Z_mag  = sqrt(R3^2 + Xnet.^2);

subplot(1, 2, 1);
% plot dua sumbu y secara manual
[ax, h1, h2] = plotyy(w_plot, Xnet, w_plot, Z_mag);
set(h1, 'LineWidth', 2, 'Color', 'b');
set(h2, 'LineWidth', 2, 'Color', 'r');
hold(ax(1), 'on');
plot(ax(1), [w_akar w_akar], [-200 200], 'g--', 'LineWidth', 1.5);
plot(ax(1), [100 5000], [0 0], 'k--', 'LineWidth', 1);
hold(ax(1), 'off');
ylabel(ax(1), 'Reaktansi Net (Ohm)');
ylabel(ax(2), '|Z| (Ohm)');
xlabel('omega (rad/s)');
title('Impedansi RLC vs Frekuensi');
legend([h1 h2], {'Im(Z)', '|Z|'}, 'Location', 'northeast');
grid(ax(1), 'on');

subplot(1, 2, 2);
semilogy(tabel3(:,1), tabel3(:,6), 'go-', 'LineWidth', 1.5, 'MarkerSize', 5);
xlabel('Iterasi');
ylabel('Error Relatif (%)');
title('Konvergensi Biseksi - RLC');
grid on;

%% ========================================================
%  RINGKASAN HASIL
% =========================================================
fprintf('========================================================\n');
fprintf('              RINGKASAN HASIL BISEKSI\n');
fprintf('========================================================\n');
fprintf('  Contoh 1 (RC)    : t  = %.6f detik\n', t_akar);
fprintf('  Contoh 2 (Dioda) : Vd = %.6f V\n',     Vd_akar);
fprintf('  Contoh 3 (RLC)   : w0 = %.4f rad/s\n', w_akar);
fprintf('========================================================\n\n');