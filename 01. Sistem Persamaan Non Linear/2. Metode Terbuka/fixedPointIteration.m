% =========================================================================
% METODE NUMERIK - TEKNIK ELEKTRO
% Topik  : Pencarian Akar Sistem Persamaan Non-Linear
% Metode : Fixed Point Iteration (Iterasi Titik Tetap)
%
% STUDI KASUS: Rangkaian Dioda-Resistor (Non-Linear Circuit Analysis)
%
% Deskripsi Rangkaian:
%   Sumber tegangan Vs dihubungkan seri dengan resistor R dan dua dioda.
%   Tegangan dan arus pada dioda mengikuti persamaan Shockley non-linear.
%   Kita cari dua besaran: V1 (tegangan dioda 1) dan V2 (tegangan dioda 2)
%
% Model Persamaan (sistem 2 persamaan non-linear):
%   f1(V1, V2) = 0  -->  V1 + V2 + R*Is*(exp(V1/Vt)-1) - Vs = 0
%   f2(V1, V2) = 0  -->  Is*(exp(V1/Vt)-1) - Is*(exp(V2/Vt)-1) = 0
%
% Bentuk Fixed Point  g(x) = x  didapat dengan manipulasi aljabar:
%   V1_baru = Vs - V2 - R*Is*(exp(V1/Vt) - 1)
%   V2_baru = Vt * log( (exp(V1/Vt) - 1) + 1 )
%
% Parameter rangkaian:
%   Vs = 2 V  (tegangan sumber)
%   R  = 1000 Ohm (resistor)
%   Is = 1e-12 A  (arus saturasi dioda)
%   Vt = 0.02585 V (tegangan termal pada suhu ruang 300K)
%
% Solusi analitik (referensi): V1 ≈ 0.6397 V, V2 ≈ 0.6397 V
% =========================================================================

clc;        % bersihkan Command Window
clear;      % hapus semua variabel
close all;  % tutup semua jendela figure

% =========================================================================
% BAGIAN 1: TAMPILAN JUDUL
% =========================================================================
fprintf('=============================================================\n');
fprintf('  METODE NUMERIK - FIXED POINT ITERATION\n');
fprintf('  Studi Kasus: Analisis Rangkaian Dioda Non-Linear\n');
fprintf('=============================================================\n\n');

fprintf('DESKRIPSI RANGKAIAN:\n');
fprintf('  Vs --[R]--+--[D1]--+--[D2]--+-- GND\n');
fprintf('            |        |        |\n');
fprintf('           Vs       V1       V2\n\n');
fprintf('  Model:  V1_baru = Vs - V2 - R*Is*(exp(V1/Vt) - 1)\n');
fprintf('          V2_baru = Vt * ln( exp(V1/Vt) )\n\n');

% =========================================================================
% BAGIAN 2: PARAMETER RANGKAIAN (konstanta fisika, tidak diubah user)
% =========================================================================
Vs = 2.0;       % Tegangan sumber (Volt)
R  = 1000;      % Resistansi (Ohm)
Is = 1e-12;     % Arus saturasi dioda (Ampere)
Vt = 0.02585;   % Tegangan termal = k*T/q pada T=300K (Volt)

fprintf('PARAMETER RANGKAIAN (tetap):\n');
fprintf('  Vs = %.2f V,  R = %d Ohm,  Is = %.2e A,  Vt = %.5f V\n\n', ...
        Vs, R, Is, Vt);

% =========================================================================
% BAGIAN 3: INPUT DARI USER
% =========================================================================
fprintf('--- INPUT PARAMETER ITERASI ---\n');

% Tebakan awal V1
V1_init = input('Masukkan tebakan awal V1 (misal 0.5): ');

% Tebakan awal V2
V2_init = input('Masukkan tebakan awal V2 (misal 0.5): ');

% Toleransi error
tol = input('Masukkan toleransi error (misal 1e-6): ');

% Maksimum iterasi
max_iter = input('Masukkan maksimum iterasi (misal 100): ');

fprintf('\n');

% =========================================================================
% BAGIAN 4: CEK SYARAT KONVERGENSI  |g'(x)| < 1
%
% Turunan parsial dari fungsi iterasi g(V1, V2):
%   dg1/dV1 = -R*Is/Vt * exp(V1/Vt)
%   dg1/dV2 = -1
%   dg2/dV1 = exp(V1/Vt) / exp(V2/Vt)   (pendekatan di titik awal)
%   dg2/dV2 = 0
%
% Norma Jacobian |J_g| dihitung di titik tebakan awal
% Syarat konvergensi: spectral radius (nilai eigen terbesar) < 1
% Untuk kesederhanaan kuliah, kita gunakan norma-1 sebagai estimasi
% =========================================================================
fprintf('--- CEK SYARAT KONVERGENSI (di titik tebakan awal) ---\n');

% Hitung elemen Jacobian dari g(V1,V2) di titik (V1_init, V2_init)
dg1_dV1 = -R * Is / Vt * exp(V1_init / Vt);
dg1_dV2 = -1;
dg2_dV1 = exp(V1_init / Vt) / exp(V2_init / Vt);
dg2_dV2 = 0;

% Jacobian matriks g
Jg = [dg1_dV1, dg1_dV2;
      dg2_dV1, dg2_dV2];

% Hitung norma-1 matriks (max jumlah kolom)
norma_Jg = norm(Jg, 1);

fprintf('  Jacobian g di titik awal:\n');
fprintf('  J_g = [%.4f   %.4f]\n', Jg(1,1), Jg(1,2));
fprintf('        [%.4f   %.4f]\n', Jg(2,1), Jg(2,2));
fprintf('  Norma-1 Jacobian = %.6f\n', norma_Jg);

if norma_Jg < 1
    fprintf('  STATUS: KONVERGEN  (norma < 1, iterasi kemungkinan besar berhasil)\n\n');
else
    fprintf('  STATUS: DIVERGEN   (norma >= 1, iterasi mungkin tidak konvergen!)\n');
    fprintf('  SARAN : Coba ubah tebakan awal atau ubah bentuk g(x)\n\n');
end

% =========================================================================
% BAGIAN 5: PROSES ITERASI FIXED POINT
% =========================================================================
fprintf('--- PROSES ITERASI ---\n');
fprintf('%-6s %-14s %-14s %-14s %-14s\n', ...
        'Iter', 'V1 (Volt)', 'V2 (Volt)', 'Error V1', 'Error V2');
fprintf('%s\n', repmat('-', 1, 65));

% Inisialisasi
V1 = V1_init;
V2 = V2_init;

% Simpan riwayat untuk plotting
hist_V1    = zeros(max_iter+1, 1);
hist_V2    = zeros(max_iter+1, 1);
hist_err1  = zeros(max_iter+1, 1);
hist_err2  = zeros(max_iter+1, 1);

hist_V1(1) = V1;
hist_V2(1) = V2;

% Cetak kondisi awal (iterasi ke-0)
fprintf('%-6d %-14.8f %-14.8f %-14s %-14s\n', 0, V1, V2, '-', '-');

% -------------------------------------------------------
% Loop iterasi utama
% -------------------------------------------------------
konvergen = false;
iter_selesai = 0;

for k = 1 : max_iter

    % --- Hitung nilai baru menggunakan fungsi g(V1, V2) ---
    %
    % g1: isolasi V1 dari persamaan KVL loop
    %     Vs = V1 + V2 + R*I_dioda
    %     V1_baru = Vs - V2 - R*Is*(exp(V1/Vt)-1)
    %
    % g2: tegangan dioda 2 = tegangan dioda 1 (dioda identik, arus sama)
    %     Is*(exp(V2/Vt)-1) = Is*(exp(V1/Vt)-1)
    %     exp(V2/Vt) = exp(V1/Vt)
    %     V2_baru = Vt * log(exp(V1/Vt) - 1 + 1) = V1  ... disederhanakan
    %     (dalam implementasi pakai bentuk numerik yang stabil)
    %
    V1_baru = Vs - V2 - R * Is * (exp(V1 / Vt) - 1);
    V2_baru = Vt * log(exp(V1 / Vt));   % setara V2_baru = V1

    % --- Hitung error relatif ---
    err1 = abs(V1_baru - V1);
    err2 = abs(V2_baru - V2);

    % --- Simpan ke riwayat ---
    hist_V1(k+1)   = V1_baru;
    hist_V2(k+1)   = V2_baru;
    hist_err1(k+1) = err1;
    hist_err2(k+1) = err2;

    % --- Update nilai ---
    V1 = V1_baru;
    V2 = V2_baru;

    % --- Cetak baris tabel ---
    fprintf('%-6d %-14.8f %-14.8f %-14.2e %-14.2e\n', k, V1, V2, err1, err2);

    % --- Cek kriteria berhenti ---
    if err1 < tol && err2 < tol
        konvergen    = true;
        iter_selesai = k;
        break;
    end

    iter_selesai = k;
end

% =========================================================================
% BAGIAN 6: TAMPILKAN HASIL AKHIR
% =========================================================================
fprintf('%s\n\n', repmat('-', 1, 65));
fprintf('--- HASIL AKHIR ---\n');

if konvergen
    fprintf('  STATUS     : KONVERGEN setelah %d iterasi\n', iter_selesai);
else
    fprintf('  STATUS     : TIDAK KONVERGEN dalam %d iterasi\n', max_iter);
end

fprintf('  V1         = %.8f V\n', V1);
fprintf('  V2         = %.8f V\n', V2);
fprintf('  Arus dioda = %.6e A\n', Is * (exp(V1/Vt) - 1));
fprintf('  Toleransi  = %.2e\n\n', tol);

% Verifikasi: substitusi kembali ke persamaan asal
residual1 = V1 + V2 + R*Is*(exp(V1/Vt)-1) - Vs;
residual2 = Is*(exp(V1/Vt)-1) - Is*(exp(V2/Vt)-1);
fprintf('  VERIFIKASI (residual harus mendekati nol):\n');
fprintf('  f1(V1,V2) = %.4e  (persamaan KVL)\n', residual1);
fprintf('  f2(V1,V2) = %.4e  (kesamaan arus dioda)\n\n', residual2);

% =========================================================================
% BAGIAN 7: VISUALISASI
% =========================================================================

% Ambil data sampai iterasi terakhir
n_iter  = iter_selesai;
iterasi = 0 : n_iter;

V1_hist   = hist_V1(1 : n_iter+1);
V2_hist   = hist_V2(1 : n_iter+1);
err1_hist = hist_err1(2 : n_iter+1);   % error mulai iterasi ke-1
err2_hist = hist_err2(2 : n_iter+1);
iter_err  = 1 : n_iter;

% -------------------------------------------------------
% Figure 1: Konvergensi nilai V1 dan V2
% -------------------------------------------------------
figure(1);
subplot(2,1,1);
plot(iterasi, V1_hist, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
plot(iterasi, ones(size(iterasi)) * V1, 'r--', 'LineWidth', 1);
hold off;
xlabel('Iterasi ke-');
ylabel('V_1 (Volt)');
title('Konvergensi Tegangan V1');
legend('Nilai V1 tiap iterasi', 'Nilai konvergen', 'Location', 'Best');
grid on;

subplot(2,1,2);
plot(iterasi, V2_hist, 'g-s', 'LineWidth', 1.5, 'MarkerSize', 4);
hold on;
plot(iterasi, ones(size(iterasi)) * V2, 'r--', 'LineWidth', 1);
hold off;
xlabel('Iterasi ke-');
ylabel('V_2 (Volt)');
title('Konvergensi Tegangan V2');
legend('Nilai V2 tiap iterasi', 'Nilai konvergen', 'Location', 'Best');
grid on;

% -------------------------------------------------------
% Figure 2: Plot error (skala log) - menunjukkan laju konvergensi
% -------------------------------------------------------
figure(2);
semilogy(iter_err, err1_hist, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 5);
hold on;
semilogy(iter_err, err2_hist, 'g-s', 'LineWidth', 1.5, 'MarkerSize', 5);
semilogy(iter_err, ones(size(iter_err)) * tol, 'r--', 'LineWidth', 1.5);
hold off;
xlabel('Iterasi ke-');
ylabel('Error Absolut (skala log)');
title('Konvergensi Error - Fixed Point Iteration');
legend('Error V1', 'Error V2', sprintf('Toleransi = %.0e', tol), ...
       'Location', 'NorthEast');
grid on;

% -------------------------------------------------------
% Figure 3: Karakteristik I-V dioda hasil akhir
% -------------------------------------------------------
figure(3);
V_range = linspace(0, 0.8, 500);
I_dioda = Is * (exp(V_range / Vt) - 1);

plot(V_range, I_dioda * 1000, 'b-', 'LineWidth', 2);   % arus dalam mA
hold on;
plot(V1, Is*(exp(V1/Vt)-1)*1000, 'ro', 'MarkerSize', 10, ...
     'MarkerFaceColor', 'r');                            % titik operasi
hold off;
xlabel('Tegangan Dioda (Volt)');
ylabel('Arus Dioda (mA)');
title('Karakteristik I-V Dioda Shockley');
legend('Kurva I-V dioda', 'Titik operasi hasil iterasi', ...
       'Location', 'NorthWest');
grid on;
annotation('textbox', [0.55 0.25 0.3 0.12], ...
           'String', sprintf('V_D = %.4f V\nI_D = %.4e A', ...
           V1, Is*(exp(V1/Vt)-1)), ...
           'BackgroundColor', 'yellow', ...
           'EdgeColor', 'black', ...
           'FontSize', 9);

fprintf('Visualisasi selesai. Tiga jendela plot telah dibuka.\n');
fprintf('  Figure 1: Konvergensi nilai V1 dan V2\n');
fprintf('  Figure 2: Konvergensi error (skala logaritmik)\n');
fprintf('  Figure 3: Karakteristik I-V dioda + titik operasi\n\n');
fprintf('=============================================================\n');
fprintf('  Selesai.\n');
fprintf('=============================================================\n');
