function [xSolution, iterTable, isConverged] = fixedPointIteration(gFunc, x0, tol, maxIter)
% FIXEDPOINTITERATION  Mencari solusi persamaan x = g(x) menggunakan metode Fixed Point Iteration
%
% Syntax:
%   [xSolution, iterTable, isConverged] = fixedPointIteration(gFunc, x0, tol, maxIter)
%
% Input:
%   gFunc    - function handle g(x), bentuk iterasi x = g(x)
%   x0       - tebakan awal (initial guess)
%   tol      - toleransi error (misal: 1e-6)
%   maxIter  - jumlah iterasi maksimum
%
% Output:
%   xSolution  - nilai solusi (akar) yang ditemukan
%   iterTable  - tabel hasil iterasi [iterasi, xLama, xBaru, errorAbs, errorRel]
%   isConverged- true jika konvergen, false jika tidak
%
% Contoh:
%   g = @(x) (x^2 + 2) / 3;
%   [sol, tbl, ok] = fixedPointIteration(g, 1.0, 1e-6, 100);

    % =========================================================
    % LANGKAH 0: Validasi input
    % =========================================================
    if nargin < 3 || isempty(tol)
        tol = 1e-6;
    end
    if nargin < 4 || isempty(maxIter)
        maxIter = 100;
    end

    fprintf('=====================================================\n');
    fprintf('       METODE FIXED POINT ITERATION\n');
    fprintf('=====================================================\n');
    fprintf('  Tebakan awal (x0)  : %.6f\n', x0);
    fprintf('  Toleransi error    : %.2e\n', tol);
    fprintf('  Iterasi maksimum   : %d\n', maxIter);
    fprintf('-----------------------------------------------------\n');
    fprintf('  %-6s  %-14s  %-14s  %-14s  %-12s\n', ...
            'Iter', 'x_lama', 'x_baru', 'Error Abs', 'Error Rel (%)');
    fprintf('-----------------------------------------------------\n');

    % =========================================================
    % LANGKAH 1: Inisialisasi variabel
    % =========================================================
    xLama      = x0;
    isConverged = false;
    iterData   = [];   % akan diisi tiap iterasi

    % =========================================================
    % LANGKAH 2: Loop iterasi utama
    % =========================================================
    for k = 1 : maxIter

        % --- LANGKAH 2a: Hitung nilai baru x menggunakan g(x) ---
        xBaru = gFunc(xLama);

        % --- LANGKAH 2b: Hitung error absolut ---
        errorAbs = abs(xBaru - xLama);

        % --- LANGKAH 2c: Hitung error relatif (%) ---
        if abs(xBaru) > eps
            errorRel = (errorAbs / abs(xBaru)) * 100;
        else
            errorRel = 0;
        end

        % --- LANGKAH 2d: Simpan data iterasi ke tabel ---
        iterData = [iterData; k, xLama, xBaru, errorAbs, errorRel]; %#ok<AGROW>

        % --- LANGKAH 2e: Tampilkan hasil iterasi ke layar ---
        fprintf('  %-6d  %-14.8f  %-14.8f  %-14.2e  %-12.6f\n', ...
                k, xLama, xBaru, errorAbs, errorRel);

        % --- LANGKAH 2f: Cek kriteria konvergensi ---
        if errorAbs < tol
            isConverged = true;
            break;
        end

        % --- LANGKAH 2g: Cek apakah nilai divergen (tidak terbatas) ---
        if isinf(xBaru) || isnan(xBaru)
            fprintf('\n  [WARNING] Iterasi divergen pada iterasi ke-%d!\n', k);
            break;
        end

        % --- LANGKAH 2h: Update x untuk iterasi berikutnya ---
        xLama = xBaru;
    end

    % =========================================================
    % LANGKAH 3: Tentukan hasil akhir
    % =========================================================
    xSolution = xBaru;
    iterTable = iterData;

    fprintf('-----------------------------------------------------\n');

    if isConverged
        fprintf('  STATUS     : KONVERGEN\n');
        fprintf('  Solusi     : x = %.10f\n', xSolution);
        fprintf('  Iterasi    : %d kali\n', k);
    else
        fprintf('  STATUS     : TIDAK KONVERGEN dalam %d iterasi\n', maxIter);
        fprintf('  Nilai terakhir : x = %.10f\n', xSolution);
    end

    fprintf('=====================================================\n\n');
end
