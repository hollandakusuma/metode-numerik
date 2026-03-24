function [akar, iterTable] = secantMethod(f, x0, x1, tol, maxIter)
% =========================================================
%  secantMethod  --  Metode Secant
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Mencari akar persamaan f(x) = 0 dengan dua tebakan awal
%  x0 dan x1, TANPA memerlukan turunan analitik f'(x).
%
%  Rumus iterasi:
%                       f(x_i) * (x_i - x_{i-1})
%  x_{i+1} = x_i  -  ——————————————————————————————
%                       f(x_i) - f(x_{i-1})
%
%  INPUT:
%    f       : function handle, contoh: @(x) x.^2 - 4
%    x0      : tebakan awal pertama
%    x1      : tebakan awal kedua
%    tol     : toleransi error (default: 1e-6)
%    maxIter : iterasi maksimum (default: 100)
%
%  OUTPUT:
%    akar      : estimasi akar persamaan
%    iterTable : tabel iterasi [iter, x_{i-1}, x_i, x_{i+1}, f(x_{i+1}), error(%)]
%
%  CONTOH PENGGUNAAN:
%    f = @(x) x.^3 - x - 2;
%    [akar, tabel] = secantMethod(f, 1, 2, 1e-8, 50);
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

    % --- nilai default ---
    if nargin < 4, tol     = 1e-6; end
    if nargin < 5, maxIter = 100;  end

    % --- inisialisasi ---
    iterTable = zeros(maxIter, 6);

    fprintf('\n========================================================\n');
    fprintf('              METODE SECANT\n');
    fprintf('========================================================\n');
    fprintf(' Iter |   x_{i-1}        |   x_i            |   x_{i+1}        |   f(x_{i+1})     |   Error(%%)\n');
    fprintf('------+------------------+------------------+------------------+------------------+----------\n');

    xPrev = x0;
    xCurr = x1;

    for i = 1:maxIter

        fPrev = f(xPrev);
        fCurr = f(xCurr);

        % --- cek pembagi nol ---
        if abs(fCurr - fPrev) < 1e-14
            warning('f(x_i) - f(x_{i-1}) = 0 pada iterasi ke-%d. Iterasi dihentikan.', i);
            break
        end

        % --- rumus secant ---
        xNext = xCurr - fCurr * (xCurr - xPrev) / (fCurr - fPrev);
        fNext = f(xNext);

        % --- error relatif (%) ---
        if abs(xNext) < 1e-14
            err = abs(xNext - xCurr) * 100;
        else
            err = abs((xNext - xCurr) / xNext) * 100;
        end

        iterTable(i, :) = [i, xPrev, xCurr, xNext, fNext, err];

        fprintf(' %4d | %16.10f | %16.10f | %16.10f | %16.10f | %9.5f%%\n', ...
                i, xPrev, xCurr, xNext, fNext, err);

        % --- kriteria berhenti ---
        if err < tol * 100 || abs(fNext) < tol
            fprintf('------+------------------+------------------+------------------+------------------+----------\n');
            fprintf(' >> Konvergen pada iterasi ke-%d\n', i);
            xCurr = xNext;
            break
        end

        % --- geser jendela ---
        xPrev = xCurr;
        xCurr = xNext;

        if i == maxIter
            warning('Mencapai batas iterasi maksimum (%d).', maxIter);
        end
    end

    akar = xCurr;
    iterTable = iterTable(1:i, :);

    fprintf('\n >> Akar yang ditemukan : x = %.10f\n', akar);
    fprintf(' >> f(akar)             : f(x) = %.4e\n', f(akar));
    fprintf(' >> Jumlah iterasi      : %d\n', i);
    fprintf('========================================================\n\n');
end
