function [akar, iter_table] = regulaFalsi(f, a, b, tol, max_iter)
% =========================================================
%  REGULA_FALSI  --  Metode Posisi Palsu (False Position)
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Mencari akar persamaan f(x) = 0 pada interval [a, b]
%  menggunakan interpolasi linear antara titik (a, f(a))
%  dan (b, f(b)) untuk menentukan tebakan berikutnya.
%
%  Rumus:
%         c = b - f(b) * (b - a) / (f(b) - f(a))
%
%  INPUT:
%    f        : function handle, contoh: @(x) x.^2 - 4
%    a        : batas bawah interval
%    b        : batas atas interval
%    tol      : toleransi error (default: 1e-6)
%    max_iter : iterasi maksimum (default: 100)
%
%  OUTPUT:
%    akar       : estimasi akar persamaan
%    iter_table : tabel iterasi [iter, a, b, c, f(c), error(%)]
%
%  CONTOH PENGGUNAAN:
%    f = @(x) x.^3 - x - 2;
%    [akar, tabel] = regula_falsi(f, 1, 2, 1e-6, 50);
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

    % --- nilai default ---
    if nargin < 4, tol      = 1e-6; end
    if nargin < 5, max_iter = 100;  end

    % --- validasi interval ---
    if f(a) * f(b) > 0
        error('f(a) dan f(b) harus berbeda tanda. Periksa interval [a, b].');
    end

    % --- inisialisasi ---
    iter_table = zeros(max_iter, 6);

    fprintf('\n========================================================\n');
    fprintf('        METODE REGULA FALSI (POSISI PALSU)\n');
    fprintf('========================================================\n');
    fprintf(' Iter |      a         |      b         |      c         |     f(c)       |   Error(%%)\n');
    fprintf('------+----------------+----------------+----------------+----------------+----------\n');

    c_lama = a;

    for i = 1:max_iter

        fa = f(a);
        fb = f(b);

        % --- rumus regula falsi ---
        c  = b - fb * (b - a) / (fb - fa);
        fc = f(c);

        % --- error relatif ---
        if i == 1
            err = 100;
        else
            err = abs((c - c_lama) / c) * 100;
        end

        iter_table(i, :) = [i, a, b, c, fc, err];

        fprintf(' %4d | %14.8f | %14.8f | %14.8f | %14.8f | %9.5f%%\n', ...
                i, a, b, c, fc, err);

        % --- kriteria berhenti ---
        if abs(fc) < tol || err < tol * 100
            fprintf('------+----------------+----------------+----------------+----------------+----------\n');
            fprintf(' >> Konvergen pada iterasi ke-%d\n', i);
            break
        end

        % --- perbaharui interval (sama logikanya dengan biseksi) ---
        if fa * fc < 0
            b = c;
        else
            a = c;
        end

        c_lama = c;

        if i == max_iter
            warning('Mencapai batas iterasi maksimum (%d).', max_iter);
        end
    end

    akar = c;
    iter_table = iter_table(1:i, :);

    fprintf('\n >> Akar yang ditemukan : x = %.10f\n', akar);
    fprintf(' >> f(akar)             : f(x) = %.4e\n', f(akar));
    fprintf(' >> Jumlah iterasi      : %d\n', i);
    fprintf('========================================================\n\n');
end
