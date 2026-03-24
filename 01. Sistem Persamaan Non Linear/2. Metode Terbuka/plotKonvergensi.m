% =========================================================
% FUNGSI BANTU (helper) - didefinisikan di bawah script
% =========================================================
 
function plotKonvergensi(iterTable, judulPlot, isConverged, gFunc)
% Membuat 3 subplot:
%   Subplot 1 - Kurva f(x) = g(x)-x dan titik solusi, range dari x0 ke solusi
%   Subplot 2 - Nilai x tiap iterasi
%   Subplot 3 - Error absolut tiap iterasi (skala log)
%
% Input:
%   iterTable  - tabel hasil iterasi dari fixedPointIteration
%   judulPlot  - string judul untuk figure
%   isConverged- true/false status konvergensi
%   gFunc      - function handle g(x); f(x) diturunkan otomatis: f(x) = g(x) - x
 
    if isempty(iterTable)
        return;
    end
 
    % --- Ambil kolom dari tabel iterasi ---
    iterVec  = iterTable(:, 1);
    xBaruVec = iterTable(:, 3);
    errorVec = iterTable(:, 4);
    xSolusi  = xBaruVec(end);       % nilai solusi = x terakhir
    x0       = iterTable(1, 2);     % tebakan awal = x_lama pada iterasi pertama
 
    % --- Turunkan f(x) otomatis dari g(x) ---
    % Persamaan x = g(x)  ekuivalen dengan  f(x) = g(x) - x = 0
    fFunc       = @(x) gFunc(x) - x;
    labelFungsi = 'f(x) = g(x) - x';
 
    % --- Range x: dari x0 sampai solusi, dengan sedikit padding 10% ---
    xKiri  = min(x0, xSolusi);
    xKanan = max(x0, xSolusi);
    padding    = max((xKanan - xKiri) * 5, 0.3);  % minimal padding 0.3
    xPlotMin   = xKiri  - padding;
    xPlotMax   = xKanan + padding;
 
    xRange = linspace(xPlotMin, xPlotMax, 300);
 
    % --- Buat figure ---
    figure;
    set(gcf, 'Name', judulPlot, 'NumberTitle', 'off');
 
    % =========================================================
    % SUBPLOT 1: Kurva f(x) = g(x)-x dan titik solusi
    % =========================================================
    subplot(3, 1, 1);
 
    % Evaluasi f(x) secara element-wise di xRange
    yRange = zeros(1, length(xRange));
    for i = 1 : length(xRange)
        try
            yRange(i) = fFunc(xRange(i));
        catch
            yRange(i) = NaN;
        end
    end
 
    % Plot kurva f(x)
    plot(xRange, yRange, 'k-', 'LineWidth', 2);
    hold on;
 
    % Garis y = 0 sebagai referensi akar
    plot([xPlotMin, xPlotMax], [0, 0], 'k--', 'LineWidth', 0.8);
 
    % Marker titik awal x0 pada kurva
    yX0 = fFunc(x0);
    plot(x0, yX0, 'gs', 'MarkerSize', 9, 'LineWidth', 2, ...
         'MarkerFaceColor', [0.2 0.7 0.2]);
 
    % Titik solusi x* pada kurva
    ySolusi = fFunc(xSolusi);
    plot(xSolusi, ySolusi, 'ro', 'MarkerSize', 10, 'LineWidth', 2, ...
         'MarkerFaceColor', 'r');
 
    % Garis vertikal putus-putus dari x* ke sumbu x
    plot([xSolusi, xSolusi], [0, ySolusi], 'r--', 'LineWidth', 1);
 
    hold off;
 
    % Anotasi teks di titik solusi
    text(xSolusi, ySolusi, sprintf('  x* = %.6f', xSolusi), ...
         'FontSize', 8, 'Color', 'r', 'VerticalAlignment', 'bottom');
 
    % Atur ylim agar tidak terpotong
    yValid   = yRange(~isnan(yRange));
    yLimTemp = [min(yValid), max(yValid)];
    if diff(yLimTemp) < eps
        yLimTemp = yLimTemp + [-1, 1];
    end
    ylim([yLimTemp(1) - 0.12*abs(yLimTemp(1)), ...
          yLimTemp(2) + 0.12*abs(yLimTemp(2))]);
 
    xlabel('x');
    ylabel('f(x)');
    title(['Fungsi Asli & Titik Solusi  |  ' judulPlot]);
    grid on;
 
    if isConverged
        legend({labelFungsi, 'y = 0', ...
                ['x_0 = ' sprintf('%.4f', x0)], ...
                ['x* = ' sprintf('%.6f', xSolusi)]}, ...
               'Location', 'best');
    else
        legend({labelFungsi, 'y = 0', ...
                ['x_0 = ' sprintf('%.4f', x0)], ...
                'Nilai terakhir'}, ...
               'Location', 'best');
    end
 
    % =========================================================
    % SUBPLOT 2: Nilai x tiap iterasi
    % =========================================================
    subplot(3, 1, 2);
    plot(iterVec, xBaruVec, 'b-o', 'LineWidth', 1.5, 'MarkerSize', 5, ...
         'MarkerFaceColor', 'b');
 
    % Garis horizontal pada nilai solusi akhir
    hold on;
    plot([iterVec(1), iterVec(end)], [xSolusi, xSolusi], ...
         'r--', 'LineWidth', 1);
    hold off;
 
    xlabel('Iterasi ke-');
    ylabel('Nilai x');
    title('Konvergensi Nilai x per Iterasi');
    legend({'x_{baru}', ['x* = ' sprintf('%.6f', xSolusi)]}, 'Location', 'best');
    grid on;
 
    % =========================================================
    % SUBPLOT 3: Error absolut tiap iterasi (skala log)
    % =========================================================
    subplot(3, 1, 3);
 
    % Pastikan tidak ada error = 0 yang merusak skala log
    errorPlot = errorVec;
    errorPlot(errorPlot == 0) = eps;
 
    semilogy(iterVec, errorPlot, 'r-s', 'LineWidth', 1.5, 'MarkerSize', 5, ...
             'MarkerFaceColor', 'r');
 
    xlabel('Iterasi ke-');
    ylabel('Error Absolut (log scale)');
    title('Penurunan Error Absolut');
    legend('|x_{baru} - x_{lama}|', 'Location', 'best');
    grid on;
 
    % --- Atur layout agar tidak tumpang tindih ---
    set(gcf, 'Position', [100, 100, 700, 750]);
end
 
 