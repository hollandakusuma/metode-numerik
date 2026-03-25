function [xSolusi, iterTable, isConverged] = gaussSeidel(A, b, x0, tol, maxIter)
% GAUSSSEIDEL  Menyelesaikan sistem persamaan linear Ax = b
%              menggunakan metode Iterasi Gauss-Seidel
%
% Syntax:
%   [xSolusi, iterTable, isConverged] = gaussSeidel(A, b, x0, tol, maxIter)
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
% Perbedaan utama dengan Jacobi:
%   Jacobi      : semua x_baru dihitung pakai x LAMA, update sekaligus di akhir
%   Gauss-Seidel: x_baru langsung dipakai untuk hitung komponen berikutnya
%
% Contoh:
%   A  = [4 -1 0; -1 4 -1; 0 -1 4];
%   b  = [3; 6; 3];
%   x0 = [0; 0; 0];
%   [x, tbl, ok] = gaussSeidel(A, b, x0, 1e-6, 50);

    % =========================================================
    % LANGKAH 0: Validasi dan inisialisasi default
    % =========================================================
    [n, kolomA] = size(A);

    if n ~= kolomA
        error('gaussSeidel: Matriks A harus persegi (n x n).');
    end
    if length(b) ~= n
        error('gaussSeidel: Panjang b harus sama dengan n.');
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
    fprintf('         METODE ITERASI GAUSS-SEIDEL\n');
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
            fprintf('      Gauss-Seidel tidak bisa dijalankan. Susun ulang persamaan.\n');
            adaDiagonalNol = true;
        end
    end
    if adaDiagonalNol
        xSolusi     = NaN(n, 1);
        iterTable   = [];
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
        fprintf('  --> Matriks strictly diagonally dominant. Gauss-Seidel DIJAMIN konvergen.\n');
    else
        fprintf('  --> [PERINGATAN] Tidak semua baris dominan. Mungkin tidak konvergen.\n');
    end

    % =========================================================
    % LANGKAH 2: Tampilkan bentuk iterasi Gauss-Seidel
    % =========================================================
    fprintf('\n  [Langkah 2] BENTUK ITERASI GAUSS-SEIDEL\n');
    fprintf('  Isolasi tiap variabel (x terbaru langsung dipakai):\n');
    for i = 1 : n
        fprintf('  x%d = ( %.4f', i, b(i));
        for j = 1 : n
            if j ~= i && j < i
                fprintf(' - (%.4f)*x%d_BARU', A(i,j), j);
            elseif j ~= i && j > i
                fprintf(' - (%.4f)*x%d_lama', A(i,j), j);
            end
        end
        fprintf(' ) / %.4f\n', A(i, i));
    end
    fprintf('\n  Keterangan: x_BARU = sudah diupdate iterasi ini\n');
    fprintf('              x_lama = belum diupdate iterasi ini\n');

    % =========================================================
    % LANGKAH 3: Inisialisasi
    % =========================================================
    fprintf('\n  [Langkah 3] TEBAKAN AWAL x0 :\n');
    for i = 1 : n
        fprintf('  x%d = %.6f\n', i, x0(i));
    end

    x           = x0;
    isConverged = false;
    iterData    = [];

    % Header tabel ringkas
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
    rowStr0 = '  %-6d';
    for i = 1 : n
        rowStr0 = [rowStr0 '  %-14.8f']; %#ok<AGROW>
    end
    rowStr0  = [rowStr0 '  %-14s\n']; %#ok<AGROW>
    rowArgs0 = {0};
    for i = 1 : n
        rowArgs0{end+1} = x(i); %#ok<AGROW>
    end
    rowArgs0{end+1} = '-';
    fprintf(rowStr0, rowArgs0{:});

    % =========================================================
    % LANGKAH 4: Loop iterasi utama
    % =========================================================
    for k = 1 : maxIter

        fprintf('\n  ----- Iterasi ke-%d -----\n', k);

        xLama = x;   % simpan salinan x lama untuk hitung error di akhir

        % -----------------------------------------------------
        % LANGKAH 4a: Update tiap komponen SATU PER SATU
        %   Begitu x(i) diperbarui, langsung dipakai untuk
        %   menghitung x(i+1) dst. — inilah ciri Gauss-Seidel
        % -----------------------------------------------------
        fprintf('  [4a] Update sekuensial (x terbaru langsung dipakai):\n\n');

        for i = 1 : n

            sigmaKiri  = 0;   % kontribusi dari x yang SUDAH diupdate (j < i)
            sigmakanan = 0;   % kontribusi dari x yang BELUM diupdate (j > i)

            for j = 1 : n
                if j < i
                    sigmaKiri = sigmaKiri + A(i, j) * x(j);
                elseif j > i
                    sigmakanan = sigmakanan + A(i, j) * x(j);
                end
            end

            xBaruI = (b(i) - sigmaKiri - sigmakanan) / A(i, i);

            % Cetak detail perhitungan komponen ke-i
            fprintf('  Hitung x%d_baru :\n', i);
            fprintf('    sigma_kiri  (j < %d, pakai x BARU) = ', i);
            if i == 1
                fprintf('0 (tidak ada)\n');
            else
                fprintf('');
                for j = 1 : i-1
                    if j == 1
                        fprintf('(%.4f)(%.8f)', A(i,j), x(j));
                    else
                        fprintf(' + (%.4f)(%.8f)', A(i,j), x(j));
                    end
                end
                fprintf(' = %.8f\n', sigmaKiri);
            end

            fprintf('    sigma_kanan (j > %d, pakai x lama) = ', i);
            if i == n
                fprintf('0 (tidak ada)\n');
            else
                for j = i+1 : n
                    if j == i+1
                        fprintf('(%.4f)(%.8f)', A(i,j), xLama(j));
                    else
                        fprintf(' + (%.4f)(%.8f)', A(i,j), xLama(j));
                    end
                end
                fprintf(' = %.8f\n', sigmakanan);
            end

            fprintf('    x%d_baru = (%.4f - %.8f - %.8f) / %.4f\n', ...
                    i, b(i), sigmaKiri, sigmakanan, A(i,i));
            fprintf('    x%d_baru = %.8f  ', i, xBaruI);

            if i > 1
                fprintf('<-- nilai BARU ini langsung dipakai untuk x%d dst.\n', i+1);
            else
                fprintf('<-- nilai BARU ini langsung dipakai untuk x%d dst.\n', i+1);
            end

            % LANGSUNG UPDATE di tempat
            x(i) = xBaruI;
            fprintf('\n');
        end

        % -----------------------------------------------------
        % LANGKAH 4b: Hitung error (norma-infinity)
        %   Bandingkan x sekarang dengan xLama sebelum iterasi
        % -----------------------------------------------------
        errorVec = abs(x - xLama);
        errorMax = max(errorVec);

        fprintf('  [4b] Hitung error tiap komponen :\n');
        for i = 1 : n
            fprintf('  |x%d_baru - x%d_lama| = |%.8f - %.8f| = %.4e\n', ...
                    i, i, x(i), xLama(i), errorVec(i));
        end
        fprintf('  Error maks (norma-inf) = %.4e\n', errorMax);

        % Simpan ke tabel
        barisTabel = [k, x', errorMax];
        iterData   = [iterData; barisTabel]; %#ok<AGROW>

        % -----------------------------------------------------
        % LANGKAH 4c: Cek konvergensi
        % -----------------------------------------------------
        fprintf('\n  [4c] Cek konvergensi: error (%.4e) < tol (%.4e) ? ', ...
                errorMax, tol);

        if errorMax < tol
            fprintf('YA --> KONVERGEN\n');
            isConverged = true;
            break;
        else
            fprintf('BELUM\n');
        end

        % Catatan: tidak ada langkah 4d "update sekaligus" seperti Jacobi
        % karena Gauss-Seidel sudah update langsung di langkah 4a
        fprintf('  [4d] x sudah terupdate langsung di langkah 4a (tidak perlu swap)\n');
    end

    % =========================================================
    % Cetak tabel ringkas semua iterasi
    % =========================================================
    fprintf('\n=====================================================\n');
    fprintf('  TABEL RINGKAS SEMUA ITERASI\n');
    fprintf('=====================================================\n');
    fprintf(headerStr, headerArgs{:});
    fprintf('  %s\n', repmat('-', 1, 8 + n*16 + 16));
    fmtStr = ['  %-6d  ' repmat('%-14.8f  ', 1, n) '%-14.4e\n'];
    for r = 1 : size(iterData, 1)
        fprintf(fmtStr, iterData(r, :));
    end

    % =========================================================
    % LANGKAH 5: Hasil akhir dan verifikasi
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
    fprintf('  Jumlah iterasi      : %d\n', size(iterData, 1));
    fprintf('  Verifikasi ||Ax-b|| : %.4e\n', normResidual);

    if isConverged
        fprintf('  STATUS              : KONVERGEN\n');
    else
        fprintf('  STATUS              : TIDAK KONVERGEN dalam %d iterasi\n', maxIter);
    end
    fprintf('=====================================================\n\n');
end
