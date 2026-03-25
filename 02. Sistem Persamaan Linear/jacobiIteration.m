function [xSolusi, iterTable, isConverged] = jacobiIteration(A, b, x0, tol, maxIter)
% JACOBIITERATION  Menyelesaikan sistem persamaan linear Ax = b
%                  menggunakan metode Iterasi Jacobi
%
% Syntax:
%   [xSolusi, iterTable, isConverged] = jacobiIteration(A, b, x0, tol, maxIter)
%
% Input:
%   A       - matriks koefisien (n x n)
%   b       - vektor sisi kanan (n x 1)
%   x0      - tebakan awal (n x 1); default: vektor nol
%   tol     - toleransi error; default: 1e-6
%   maxIter - jumlah iterasi maksimum; default: 100
%
% Output:
%   xSolusi    - vektor solusi akhir (n x 1)
%   iterTable  - tabel iterasi [k, x1, x2, ..., xn, error]
%   isConverged- true jika konvergen
%
% Contoh:
%   A  = [4 -1 0; -1 4 -1; 0 -1 4];
%   b  = [3; 6; 3];
%   x0 = [0; 0; 0];
%   [x, tbl, ok] = jacobiIteration(A, b, x0, 1e-6, 50);

    % =========================================================
    % LANGKAH 0: Validasi dan inisialisasi default
    % =========================================================
    [n, kolomA] = size(A);

    if n ~= kolomA
        error('jacobiIteration: Matriks A harus persegi (n x n).');
    end
    if length(b) ~= n
        error('jacobiIteration: Panjang b harus sama dengan n.');
    end
    if nargin < 3 || isempty(x0)
        x0 = zeros(n, 1);
    end
    if nargin < 4 || isempty(tol)
        tol = 1e-6;
    end
    if nargin < 5 || isempty(maxIter)
        maxIter = 100;
    end

    b  = b(:);
    x0 = x0(:);

    % =========================================================
    % LANGKAH 1: Cek elemen diagonal dan dominansi diagonal
    % =========================================================
    fprintf('=====================================================\n');
    fprintf('           METODE ITERASI JACOBI\n');
    fprintf('=====================================================\n');
    fprintf('  Ukuran sistem : %d persamaan, %d variabel\n', n, n);
    fprintf('  Toleransi     : %.2e\n', tol);
    fprintf('  Maks iterasi  : %d\n', maxIter);
    fprintf('-----------------------------------------------------\n');

    fprintf('\n  [Langkah 1] CEK ELEMEN DIAGONAL\n');
    adaDiagonalNol = false;
    for i = 1 : n
        if abs(A(i, i)) < 1e-12
            fprintf('  --> ELEMEN DIAGONAL A(%d,%d) = 0!\n', i, i);
            fprintf('      Jacobi tidak bisa dijalankan. Susun ulang persamaan.\n');
            adaDiagonalNol = true;
        end
    end
    if adaDiagonalNol
        xSolusi    = NaN(n, 1);
        iterTable  = [];
        isConverged = false;
        fprintf('=====================================================\n\n');
        return;
    end
    fprintf('  --> Semua elemen diagonal valid.\n');

    fprintf('\n  [Langkah 1b] CEK DOMINANSI DIAGONAL\n');
    semuaDominan = true;
    for i = 1 : n
        jumlahLain = 0;
        for j = 1 : n
            if j ~= i
                jumlahLain = jumlahLain + abs(A(i, j));
            end
        end
        if abs(A(i, i)) > jumlahLain
            status = 'DOMINAN';
        else
            status = 'TIDAK dominan (konvergensi tidak dijamin)';
            semuaDominan = false;
        end
        fprintf('  Baris %d : |%.4f| vs %.4f  --> %s\n', ...
                i, A(i, i), jumlahLain, status);
    end
    if semuaDominan
        fprintf('  --> Matriks strictly diagonally dominant. Jacobi DIJAMIN konvergen.\n');
    else
        fprintf('  --> [PERINGATAN] Tidak semua baris dominan. Mungkin tidak konvergen.\n');
    end

    % =========================================================
    % LANGKAH 2: Tampilkan bentuk iterasi x = D^-1 (b - (L+U)x)
    % =========================================================
    fprintf('\n  [Langkah 2] BENTUK ITERASI JACOBI\n');
    fprintf('  Isolasi tiap variabel dari persamaannya masing-masing:\n');
    for i = 1 : n
        fprintf('  x%d = ( %.4f', i, b(i));
        for j = 1 : n
            if j ~= i
                fprintf(' - (%.4f)*x%d', A(i,j), j);
            end
        end
        fprintf(' ) / %.4f\n', A(i, i));
    end

    % =========================================================
    % LANGKAH 3: Inisialisasi iterasi
    % =========================================================
    fprintf('\n  [Langkah 3] TEBAKAN AWAL x0 :\n');
    for i = 1 : n
        fprintf('  x%d = %.6f\n', i, x0(i));
    end

    x           = x0;
    isConverged = false;
    iterData    = [];

    % Header tabel iterasi
    fprintf('\n=====================================================\n');
    fprintf('  TABEL ITERASI\n');
    fprintf('=====================================================\n');
    headerStr = '  %-6s';
    for i = 1 : n
        headerStr = [headerStr '  %-14s']; %#ok<AGROW>
    end
    headerStr = [headerStr '  %-14s\n']; %#ok<AGROW>

    headerArgs = {'Iter'};
    for i = 1 : n
        headerArgs{end+1} = sprintf('x%d', i); %#ok<AGROW>
    end
    headerArgs{end+1} = 'Error';
    fprintf(headerStr, headerArgs{:});
    fprintf('  %s\n', repmat('-', 1, 8 + n*16 + 16));

    % Cetak baris iterasi ke-0 (tebakan awal)
    rowStr = '  %-6d';
    for i = 1 : n
        rowStr = [rowStr '  %-14.8f']; %#ok<AGROW>
    end
    rowStr = [rowStr '  %-14s\n']; %#ok<AGROW>
    rowArgs = {0};
    for i = 1 : n
        rowArgs{end+1} = x(i); %#ok<AGROW>
    end
    rowArgs{end+1} = '-';
    fprintf(rowStr, rowArgs{:});

    % =========================================================
    % LANGKAH 4: Loop iterasi utama
    % =========================================================
    for k = 1 : maxIter

        fprintf('\n  ----- Iterasi ke-%d -----\n', k);

        % -----------------------------------------------------
        % LANGKAH 4a: Hitung semua x_baru menggunakan x LAMA
        %   (UPDATE SIMULTAN — ciri khas Jacobi)
        % -----------------------------------------------------
        fprintf('  [4a] Hitung x_baru pakai nilai x LAMA (update simultan):\n');
        xBaru = zeros(n, 1);

        for i = 1 : n
            sigma = 0;
            for j = 1 : n
                if j ~= i
                    sigma = sigma + A(i, j) * x(j);
                end
            end
            xBaru(i) = (b(i) - sigma) / A(i, i);
            fprintf('  x%d_baru = (%.4f - (%.4f)) / %.4f = %.8f\n', ...
                    i, b(i), sigma, A(i, i), xBaru(i));
        end

        % -----------------------------------------------------
        % LANGKAH 4b: Hitung error (norma-infinity)
        %   error = max|x_baru(i) - x(i)|
        % -----------------------------------------------------
        errorVec = abs(xBaru - x);
        errorMax = max(errorVec);

        fprintf('\n  [4b] Hitung error tiap komponen :\n');
        for i = 1 : n
            fprintf('  |x%d_baru - x%d_lama| = |%.8f - %.8f| = %.4e\n', ...
                    i, i, xBaru(i), x(i), errorVec(i));
        end
        fprintf('  Error maks (norma-inf) = %.4e\n', errorMax);

        % -----------------------------------------------------
        % LANGKAH 4c: Cek konvergensi
        % -----------------------------------------------------
        fprintf('\n  [4c] Cek konvergensi: error (%.4e) < tol (%.4e) ? ', ...
                errorMax, tol);

        % Simpan baris ke tabel
        barisTabel = [k, xBaru', errorMax];
        iterData   = [iterData; barisTabel]; %#ok<AGROW>

        % Cetak ke tabel ringkas
        rowNumArgs = {k};
        for i = 1 : n
            rowNumArgs{end+1} = xBaru(i); %#ok<AGROW>
        end
        rowNumArgs{end+1} = errorMax;
        rowStrNum = '  %-6d';
        for i = 1 : n
            rowStrNum = [rowStrNum '  %-14.8f']; %#ok<AGROW>
        end
        rowStrNum = [rowStrNum '  %-14.4e\n']; %#ok<AGROW>

        if errorMax < tol
            fprintf('YA --> KONVERGEN\n');
            isConverged = true;
            x           = xBaru;
            break;
        else
            fprintf('BELUM\n');
        end

        % -----------------------------------------------------
        % LANGKAH 4d: Update x (ganti sekaligus — simultan)
        % -----------------------------------------------------
        fprintf('  [4d] Update: x <-- x_baru (semua diganti sekaligus)\n');
        x = xBaru;
    end

    % =========================================================
    % Cetak tabel ringkas
    % =========================================================
    fprintf('\n=====================================================\n');
    fprintf('  TABEL RINGKAS SEMUA ITERASI\n');
    fprintf('=====================================================\n');
    fprintf(headerStr, headerArgs{:});
    fprintf('  %s\n', repmat('-', 1, 8 + n*16 + 16));
    for r = 1 : size(iterData, 1)
        rowPrint = {'  %-6d'};
        args     = {iterData(r, 1)};
        for i = 1 : n
            rowPrint{end+1} = '%-14.8f  '; %#ok<AGROW>
            args{end+1}     = iterData(r, i+1); %#ok<AGROW>
        end
        args{end+1} = iterData(r, end);
        fmtStr = ['  %-6d  ' repmat('%-14.8f  ', 1, n) '%-14.4e\n'];
        fprintf(fmtStr, iterData(r, :));
    end

    % =========================================================
    % LANGKAH 5: Tampilkan hasil akhir
    % =========================================================
    xSolusi   = x;
    iterTable = iterData;

    fprintf('\n=====================================================\n');
    fprintf('  HASIL AKHIR\n');
    fprintf('=====================================================\n');
    for i = 1 : n
        fprintf('  x%d = %14.8f\n', i, xSolusi(i));
    end

    residual     = A * xSolusi - b;
    normResidual = norm(residual);
    fprintf('-----------------------------------------------------\n');
    fprintf('  Jumlah iterasi    : %d\n', size(iterData, 1));
    fprintf('  Verifikasi ||Ax-b|| = %.4e\n', normResidual);

    if isConverged
        fprintf('  STATUS            : KONVERGEN\n');
    else
        fprintf('  STATUS            : TIDAK KONVERGEN dalam %d iterasi\n', maxIter);
    end
    fprintf('=====================================================\n\n');
end
