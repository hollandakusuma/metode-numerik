function plotSistem3x3(A, b, xSol, judul)
% PLOTSISTEM3X3  Visualisasi nilai solusi dan residual untuk sistem 3x3
%                Kompatibel dengan MATLAB R2015a/b
%
% Input:
%   A     - matriks koefisien nxn
%   b     - vektor sisi kanan nx1
%   xSol  - vektor solusi nx1
%   judul - string judul figure

    if any(isnan(xSol))
        fprintf('  [plotSistem3x3] Tidak ada solusi untuk divisualisasikan.\n');
        return;
    end

    n = length(xSol);

    figure;
    set(gcf, 'Name', judul, 'NumberTitle', 'off');

    % =========================================================
    % Subplot 1: Bar chart nilai solusi
    % =========================================================
    subplot(1, 2, 1);

    bar(1:n, xSol, 0.5, 'FaceColor', [0.2 0.5 0.8]);
    xlabel('Variabel');
    ylabel('Nilai x_i');
    title('Nilai Solusi x');
    grid on;

    % Label sumbu-x: x_1, x_2, ... (kompatibel MATLAB 2015)
    labelX = cell(1, n);
    for i = 1 : n
        labelX{i} = sprintf('x_%d', i);
    end
    set(gca, 'XTick', 1:n, 'XTickLabel', labelX);

    % Anotasi nilai di atas tiap bar
    yOffset = 0.05 * max(abs(xSol) + eps);
    for i = 1 : n
        text(i, xSol(i) + sign(xSol(i)) * yOffset, ...
             sprintf('%.4f', xSol(i)), ...
             'HorizontalAlignment', 'center', 'FontSize', 9);
    end

    % =========================================================
    % Subplot 2: Bar chart residual per persamaan
    % =========================================================
    subplot(1, 2, 2);

    residual    = A * xSol - b;
    absResidual = abs(residual);

    bar(1:n, absResidual, 0.5, 'FaceColor', [0.8 0.3 0.2]);
    xlabel('Persamaan');
    ylabel('|Ax - b|_i');
    title('Residual per Persamaan');
    grid on;

    % Label sumbu-x: P1, P2, ... (kompatibel MATLAB 2015)
    labelP = cell(1, n);
    for i = 1 : n
        labelP{i} = sprintf('P%d', i);
    end
    set(gca, 'XTick', 1:n, 'XTickLabel', labelP);

    % Anotasi nilai residual
    for i = 1 : n
        text(i, absResidual(i) + 0.05 * max(absResidual + eps), ...
             sprintf('%.2e', absResidual(i)), ...
             'HorizontalAlignment', 'center', 'FontSize', 8);
    end

    % Judul keseluruhan figure (kompatibel MATLAB 2015: pakai annotation)
    axes('Position', [0 0 1 1], 'Visible', 'off');
    text(0.5, 0.98, judul, ...
         'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', ...
         'FontSize', 11, 'FontWeight', 'bold', 'Units', 'normalized');

    set(gcf, 'Position', [100, 100, 750, 380]);
end
