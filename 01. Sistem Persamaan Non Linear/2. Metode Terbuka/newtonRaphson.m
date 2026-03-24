function [akar, iter_table] = newtonRaphson(f, df, x0, tol, max_iter)
% =========================================================
%  NEWTON_RAPHSON  --  Metode Newton-Raphson
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Mencari akar persamaan f(x) = 0 dengan tebakan awal x0
%
%  Rumus iterasi:
%              f(x_i)
%  x_{i+1} = x_i - ———————
%              f'(x_i)
%
%  INPUT:
%    f        : function handle fungsi,    contoh: @(x) x.^2 - 4
%    df       : function handle turunan,   contoh: @(x) 2.*x
%    x0       : tebakan awal
%    tol      : toleransi error (default: 1e-6)
%    max_iter : iterasi maksimum (default: 100)
%
%  OUTPUT:
%    akar       : estimasi akar persamaan
%    iter_table : tabel iterasi [iter, x_i, f(x_i), df(x_i), x_{i+1}, error(%)]
%
%  CONTOH PENGGUNAAN:
%    f  = @(x) x.^3 - x - 2;
%    df = @(x) 3.*x.^2 - 1;
%    [akar, tabel] = newton_raphson(f, df, 1.5, 1e-8, 50);
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

    % --- nilai default ---
    if nargin < 4, tol      = 1e-6; end
    if nargin < 5, max_iter = 100;  end

    % --- validasi: turunan di x0 tidak boleh nol ---
    if abs(df(x0)) < 1e-14
        error('f''(x0) = 0 di titik awal. Pilih tebakan awal x0 yang lain.');
    end

    % --- inisialisasi ---
    iter_table = zeros(max_iter, 6);

    fprintf('\n========================================================\n');
    fprintf('           METODE NEWTON-RAPHSON\n');
    fprintf('========================================================\n');
    fprintf(' Iter |     x_i          |     f(x_i)       |    f''(x_i)      |   x_{i+1}        |   Error(%%)\n');
    fprintf('------+------------------+------------------+------------------+------------------+----------\n');

    xi = x0;

    for i = 1:max_iter

        fxi  = f(xi);
        dfxi = df(xi);

        % --- cek turunan nol di tengah iterasi ---
        if abs(dfxi) < 1e-14
            warning('f''(x) = 0 pada iterasi ke-%d. Iterasi dihentikan.', i);
            break
        end

        % --- rumus Newton-Raphson ---
        xi_baru = xi - fxi / dfxi;

        % --- error relatif (%) ---
        if abs(xi_baru) < 1e-14
            err = abs(xi_baru - xi) * 100;
        else
            err = abs((xi_baru - xi) / xi_baru) * 100;
        end

        iter_table(i, :) = [i, xi, fxi, dfxi, xi_baru, err];

        fprintf(' %4d | %16.10f | %16.10f | %16.10f | %16.10f | %9.5f%%\n', ...
                i, xi, fxi, dfxi, xi_baru, err);

        % --- kriteria berhenti ---
        if err < tol * 100 || abs(fxi) < tol
            fprintf('------+------------------+------------------+------------------+------------------+----------\n');
            fprintf(' >> Konvergen pada iterasi ke-%d\n', i);
            xi = xi_baru;
            break
        end

        xi = xi_baru;

        if i == max_iter
            warning('Mencapai batas iterasi maksimum (%d).', max_iter);
        end
    end

    akar = xi;
    iter_table = iter_table(1:i, :);

    fprintf('\n >> Akar yang ditemukan : x = %.10f\n', akar);
    fprintf(' >> f(akar)             : f(x) = %.4e\n', f(akar));
    fprintf(' >> Jumlah iterasi      : %d\n', i);
    fprintf('========================================================\n\n');
end
