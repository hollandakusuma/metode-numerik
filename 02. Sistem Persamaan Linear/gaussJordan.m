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
%   xSolusi     - vektor solusi x (n x 1)
%   mAugmentasi - matriks augmented akhir [I | x] setelah eliminasi
%   isSingular  - true jika matriks singular (tidak ada solusi unik)
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
        error('gaussJordan: Matriks A harus berbentuk persegi (n x n).');
    end
    if length(b) ~= n
        error('gaussJordan: Ukuran vektor b harus sama dengan jumlah baris A.');
    end

    % Pastikan b berupa vektor kolom
    b = b(:);

    fprintf('=====================================================\n');
    fprintf('       METODE ELIMINASI GAUSS-JORDAN\n');
    fprintf('=====================================================\n');
    fprintf('  Ukuran sistem : %d persamaan, %d variabel\n', n, n);
    fprintf('-----------------------------------------------------\n');

    % =========================================================
    % LANGKAH 1: Bentuk matriks augmented [A | b]
    % =========================================================
    M = [A, b];   % matriks augmented ukuran n x (n+1)

    fprintf('\n  Matriks Augmented Awal [A | b]:\n');
    cetakMatriks(M, n);

    isSingular = false;

    % =========================================================
    % LANGKAH 2: Proses eliminasi kolom demi kolom
    % =========================================================
    for j = 1 : n

        % -----------------------------------------------------
        % LANGKAH 2a: Partial Pivoting
        %   Cari baris dengan nilai absolut terbesar di kolom j
        %   mulai dari baris j ke bawah → swap untuk stabilitas numerik
        % -----------------------------------------------------
        [~, idxMax] = max(abs(M(j:n, j)));
        idxMax      = idxMax + j - 1;   % sesuaikan indeks relatif ke absolut

        if idxMax ~= j
            M([j, idxMax], :) = M([idxMax, j], :);   % tukar baris
            fprintf('\n  [Pivot] Tukar baris %d <-> baris %d\n', j, idxMax);
        end

        % -----------------------------------------------------
        % LANGKAH 2b: Cek singularitas
        %   Jika elemen pivot mendekati nol → matriks singular
        % -----------------------------------------------------
        pivotVal = M(j, j);

        if abs(pivotVal) < 1e-12
            fprintf('\n  [WARNING] Elemen pivot kolom %d ≈ 0.\n', j);
            fprintf('  Matriks kemungkinan singular atau sistem tidak memiliki solusi unik.\n');
            isSingular  = true;
            xSolusi     = NaN(n, 1);
            mAugmentasi = M;
            return;
        end

        % -----------------------------------------------------
        % LANGKAH 2c: Normalisasi baris pivot
        %   Bagi seluruh elemen baris j dengan pivot
        %   sehingga elemen diagonal M(j,j) menjadi 1
        % -----------------------------------------------------
        M(j, :) = M(j, :) / pivotVal;

        % -----------------------------------------------------
        % LANGKAH 2d: Eliminasi ke semua baris lain
        %   Nolkan semua elemen di kolom j selain baris j
        %   (ke atas DAN ke bawah — inilah yang membedakan
        %    Gauss-Jordan dari Eliminasi Gauss biasa)
        % -----------------------------------------------------
        for i = 1 : n
            if i ~= j
                faktor  = M(i, j);
                M(i, :) = M(i, :) - faktor * M(j, :);
            end
        end

        fprintf('\n  Setelah eliminasi kolom ke-%d:\n', j);
        cetakMatriks(M, n);
    end

    % =========================================================
    % LANGKAH 3: Baca solusi dari kolom terakhir
    %   Matriks M sekarang sudah berbentuk [I | x]
    %   sehingga solusi langsung ada di kolom ke-(n+1)
    % =========================================================
    xSolusi     = M(:, n+1);
    mAugmentasi = M;

    % =========================================================
    % LANGKAH 4: Tampilkan hasil
    % =========================================================
    fprintf('\n=====================================================\n');
    fprintf('  HASIL SOLUSI\n');
    fprintf('=====================================================\n');
    for i = 1 : n
        fprintf('  x%d = %12.8f\n', i, xSolusi(i));
    end

    % =========================================================
    % LANGKAH 5: Verifikasi — hitung residual Ax - b
    % =========================================================
    residual    = A * xSolusi - b;
    normResidual = norm(residual);

    fprintf('-----------------------------------------------------\n');
    fprintf('  Verifikasi  ||Ax - b|| = %.4e\n', normResidual);

    if normResidual < 1e-8
        fprintf('  STATUS      : SOLUSI VALID\n');
    else
        fprintf('  STATUS      : PERLU DICEK (residual besar)\n');
    end
    fprintf('=====================================================\n\n');
end


% =========================================================
% FUNGSI BANTU: Cetak matriks augmented ke layar
% =========================================================
function cetakMatriks(M, n)
    [nBaris, nKolom] = size(M);
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
