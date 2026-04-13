function [a0, a1, hasil] = regresiLinear(x, y)
% =========================================================
%  regresiLinear  --  Regresi Linear Sederhana
%  Kompatibel: MATLAB 2015 ke atas
% =========================================================
%  Mencari garis terbaik y = a0 + a1*x yang paling
%  mendekati sekumpulan data (x, y) menggunakan
%  metode Least Squares (Kuadrat Terkecil).
%
%  Rumus:
%         n*sum(xi*yi) - sum(xi)*sum(yi)
%  a1 = ————————————————————————————————————
%         n*sum(xi^2) - (sum(xi))^2
%
%  a0 = y_bar - a1 * x_bar
%
%  INPUT:
%    x  : vektor data variabel bebas  (1 x n atau n x 1)
%    y  : vektor data variabel terikat (1 x n atau n x 1)
%
%  OUTPUT:
%    a0    : konstanta (intercept)
%    a1    : koefisien kemiringan (slope)
%    hasil : struct berisi statistik regresi
%              hasil.r      = koefisien korelasi
%              hasil.r2     = koefisien determinasi
%              hasil.Se     = standar error estimasi
%              hasil.yHat   = nilai prediksi
%              hasil.residu = residu (y - yHat)
%
%  CONTOH PENGGUNAAN:
%    x = [1 2 3 4 5];
%    y = [2.1 3.9 6.2 7.8 10.1];
%    [a0, a1, hasil] = regresiLinear(x, y);
%
%  Teknik Elektro - Metode Numerik
%  Universitas Maritim Raja Ali Haji
% =========================================================

    % --- pastikan vektor kolom ---
    x = x(:);
    y = y(:);
    n = length(x);

    if n ~= length(y)
        error('Panjang vektor x dan y harus sama.');
    end
    if n < 2
        error('Minimal 2 data diperlukan.');
    end

    % -------------------------------------------------------
    %  ALGORITMA LEAST SQUARES
    % -------------------------------------------------------
    % Langkah 1: Hitung komponen jumlah
    sumX   = sum(x);
    sumY   = sum(y);
    sumXY  = sum(x .* y);
    sumX2  = sum(x .^ 2);
    sumY2  = sum(y .^ 2);

    % Langkah 2: Hitung koefisien regresi
    a1 = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX^2);
    a0 = (sumY - a1 * sumX) / n;

    % Langkah 3: Hitung nilai prediksi dan residu
    yHat   = a0 + a1 .* x;
    residu = y - yHat;

    % Langkah 4: Hitung statistik kualitas regresi
    % Standar error estimasi
    Se = sqrt(sum(residu .^ 2) / (n - 2));

    % Koefisien korelasi (r) dan determinasi (r^2)
    r  = (n*sumXY - sumX*sumY) / ...
         sqrt((n*sumX2 - sumX^2) * (n*sumY2 - sumY^2));
    r2 = r^2;

    % -------------------------------------------------------
    %  TAMPILKAN HASIL KE COMMAND WINDOW
    % -------------------------------------------------------
    xBar = sumX / n;
    yBar = sumY / n;

    fprintf('\n========================================================\n');
    fprintf('              REGRESI LINEAR SEDERHANA\n');
    fprintf('            Metode Least Squares (Kuadrat Terkecil)\n');
    fprintf('========================================================\n');
    fprintf(' Jumlah data (n)         : %d\n', n);
    fprintf(' Rata-rata x (x_bar)     : %.4f\n', xBar);
    fprintf(' Rata-rata y (y_bar)     : %.4f\n', yBar);
    fprintf('--------------------------------------------------------\n');
    fprintf(' sum(xi)                 : %.4f\n', sumX);
    fprintf(' sum(yi)                 : %.4f\n', sumY);
    fprintf(' sum(xi*yi)              : %.4f\n', sumXY);
    fprintf(' sum(xi^2)               : %.4f\n', sumX2);
    fprintf('--------------------------------------------------------\n');
    fprintf(' Slope     a1            : %.6f\n', a1);
    fprintf(' Intercept a0            : %.6f\n', a0);
    fprintf('--------------------------------------------------------\n');
    fprintf(' Persamaan regresi       : y = %.4f + %.4f * x\n', a0, a1);
    fprintf(' Koefisien korelasi  r   : %.6f\n', r);
    fprintf(' Koefisien determinasi r2: %.6f (%.2f%%)\n', r2, r2*100);
    fprintf(' Standar error Se        : %.6f\n', Se);
    fprintf('========================================================\n\n');

    % -------------------------------------------------------
    %  TABEL DATA, PREDIKSI, DAN RESIDU
    % -------------------------------------------------------
    fprintf(' No |     x      |     y      |   y_hat    |   residu\n');
    fprintf('----+------------+------------+------------+------------\n');
    for k = 1:n
        fprintf(' %2d | %10.4f | %10.4f | %10.4f | %10.4f\n', ...
                k, x(k), y(k), yHat(k), residu(k));
    end
    fprintf('----+------------+------------+------------+------------\n\n');

    % -------------------------------------------------------
    %  SIMPAN KE STRUCT OUTPUT
    % -------------------------------------------------------
    hasil.r      = r;
    hasil.r2     = r2;
    hasil.Se     = Se;
    hasil.yHat   = yHat;
    hasil.residu = residu;
    hasil.n      = n;
    hasil.xBar   = xBar;
    hasil.yBar   = yBar;
end
