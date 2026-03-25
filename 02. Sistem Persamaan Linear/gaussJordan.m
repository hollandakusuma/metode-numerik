function [xSolusi, mAugmentasi, isSingular] = gaussJordan(A, b)
% GAUSSJORDAN  Menyelesaikan sistem persamaan linear Ax = b
%              menggunakan metode Eliminasi Gauss-Jordan
%
% Syntax:
%   [xSolusi, mAugmentasi, isSingular] = gaussJordan(A, b)
%
% Input:
%   A  - matriks koefisien (n x n)
%   b  - vektor sisi kanan (n x 1)
%
% Output:
%   xSolusi     - vektor solusi x (n x 1); berisi NaN jika singular
%   mAugmentasi - matriks augmented akhir setelah eliminasi
%   isSingular  - true jika matriks singular
%
% Contoh:
%   A = [2 1 -1; -3 -1 2; -2 1 2];
%   b = [8; -11; -3];
%   [x, M, sing] = gaussJordan(A, b);

    % =========================================================
    % LANGKAH 0: Validasi input
    % =========================================================
    [n, kolomA] = size(A);

    if n ~= kolomA
        error('gaussJordan: Matriks A harus persegi (n x n).');
    end
    if length(b) ~= n
        error('gaussJordan: Panjang vektor b harus sama dengan n.');
    end

    b = b(:);   % pastikan vektor kolom

    fprintf('=====================================================\n');
    fprintf('         METODE ELIMINASI GAUSS-JORDAN\n');
    fprintf('=====================================================\n');
    fprintf('  Ukuran sistem : %d persamaan, %d variabel\n', n, n);
    fprintf('-----------------------------------------------------\n');

    % =========================================================
    % LANGKAH 1: Bentuk matriks augmented [A | b]
    % =========================================================
    M = [A, b];

    fprintf('\n  Matriks Augmented Awal [A | b] :\n');
    tampilkanMatriks(M, n);

    isSingular = false;

    % =========================================================
    % LANGKAH 2: Eliminasi kolom per kolom (j = 1 .. n)
    % =========================================================
    for j = 1 : n

        fprintf('\n#####################################################\n');
        fprintf('  ITERASI KOLOM KE-%d\n', j);
        fprintf('#####################################################\n');

        % -------------------------------------------------
        % LANGKAH 2a: Partial Pivoting
        %   Cari baris dengan |nilai| terbesar di kolom j
        %   mulai dari baris j ke bawah, lalu tukar
        % -------------------------------------------------
        fprintf('\n  [Langkah 2a] PARTIAL PIVOTING pada kolom %d\n', j);
        fprintf('  Cari |nilai terbesar| di kolom %d, baris %d s/d %d :\n', j, j, n);

        for i = j : n
            fprintf('    Baris %d : |M(%d,%d)| = |%.4f| = %.4f\n', ...
                    i, i, j, M(i, j), abs(M(i, j)));
        end

        [~, idxMax] = max(abs(M(j:n, j)));
        idxMax      = idxMax + j - 1;

        if idxMax == j
            fprintf('  --> Pivot terbesar sudah di baris %d, tidak perlu tukar.\n', j);
        else
            fprintf('  --> Nilai terbesar ada di baris %d (|%.4f|)\n', ...
                    idxMax, abs(M(idxMax, j)));
            fprintf('  --> Tukar baris %d <-> baris %d\n', j, idxMax);
            barisTmp     = M(j, :);
            M(j, :)      = M(idxMax, :);
            M(idxMax, :) = barisTmp;
            fprintf('\n  Matriks setelah pertukaran baris :\n');
            tampilkanMatriks(M, n);
        end

        % -------------------------------------------------
        % LANGKAH 2b: Cek singularitas
        %   Jika elemen pivot mendekati nol, matriks singular
        % -------------------------------------------------
        pivotVal = M(j, j);

        fprintf('\n  [Langkah 2b] CEK SINGULARITAS\n');
        fprintf('  Elemen pivot M(%d,%d) = %.6f\n', j, j, pivotVal);

        if abs(pivotVal) < 1e-12
            fprintf('  --> PIVOT MENDEKATI NOL!\n');
            fprintf('  --> Matriks singular - solusi unik tidak ada.\n');
            isSingular  = true;
            xSolusi     = NaN(n, 1);
            mAugmentasi = M;
            fprintf('=====================================================\n\n');
            return;
        else
            fprintf('  --> Pivot valid, lanjut ke normalisasi.\n');
        end

        % -------------------------------------------------
        % LANGKAH 2c: Normalisasi baris pivot
        %   Bagi seluruh baris j dengan pivotVal
        %   sehingga M(j,j) menjadi 1
        % -------------------------------------------------
        fprintf('\n  [Langkah 2c] NORMALISASI baris %d\n', j);
        fprintf('  R%d  <--  R%d / %.4f\n', j, j, pivotVal);

        M(j, :) = M(j, :) / pivotVal;

        fprintf('  Baris %d setelah normalisasi :\n', j);
        fprintf('  |');
        for k = 1 : size(M, 2)
            if k == n + 1
                fprintf('  |');
            end
            fprintf(' %10.4f', M(j, k));
        end
        fprintf('  |\n');

        % -------------------------------------------------
        % LANGKAH 2d: Eliminasi ke semua baris lain
        %   Nolkan elemen kolom j di semua baris selain j
        %   ke ATAS dan ke BAWAH sekaligus
        %   (inilah perbedaan Gauss-Jordan vs Gauss biasa)
        % -------------------------------------------------
        fprintf('\n  [Langkah 2d] ELIMINASI semua baris selain baris %d\n', j);

        for i = 1 : n
            if i ~= j
                faktor = M(i, j);
                if abs(faktor) > 1e-14
                    fprintf('    R%d  <--  R%d - (%.4f) x R%d\n', i, i, faktor, j);
                    M(i, :) = M(i, :) - faktor * M(j, :);
                else
                    fprintf('    R%d  --> elemen sudah 0, dilewati\n', i);
                end
            end
        end

        fprintf('\n  Matriks setelah eliminasi kolom %d :\n', j);
        tampilkanMatriks(M, n);
    end

    % =========================================================
    % LANGKAH 3: Baca solusi dari kolom terakhir
    %   M sekarang berbentuk [I | x]
    %   solusi langsung ada di kolom ke-(n+1)
    % =========================================================
    xSolusi     = M(:, n + 1);
    mAugmentasi = M;

    % =========================================================
    % LANGKAH 4: Tampilkan hasil solusi
    % =========================================================
    fprintf('\n=====================================================\n');
    fprintf('  SOLUSI\n');
    fprintf('=====================================================\n');
    for i = 1 : n
        fprintf('  x%d = %14.8f\n', i, xSolusi(i));
    end

    % =========================================================
    % LANGKAH 5: Verifikasi — hitung residual ||Ax - b||
    % =========================================================
    residual     = A * xSolusi - b;
    normResidual = norm(residual);

    fprintf('-----------------------------------------------------\n');
    fprintf('  Verifikasi  ||Ax - b|| = %.4e\n', normResidual);
    if normResidual < 1e-8
        fprintf('  STATUS              : SOLUSI VALID\n');
    else
        fprintf('  STATUS              : RESIDUAL BESAR, periksa sistem\n');
    end
    fprintf('=====================================================\n\n');
end


% =========================================================
% FUNGSI LOKAL: tampilkanMatriks
%   Cetak matriks augmented dengan pemisah kolom b
%   Fungsi lokal boleh ada di dalam function file (.m)
% =========================================================
function tampilkanMatriks(M, n)
    nBaris = size(M, 1);
    nKolom = size(M, 2);
    for i = 1 : nBaris
        fprintf('  |');
        for k = 1 : nKolom
            if k == n + 1
                fprintf('  |');   % pemisah antara A dan b
            end
            fprintf(' %10.4f', M(i, k));
        end
        fprintf('  |\n');
    end
end