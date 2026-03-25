function plotSistem2x2(A, b, xSol, judul)
% PLOTSISTEM2X2  Visualisasi dua garis persamaan dan titik potongnya
%
% Input:
%   A     - matriks koefisien 2x2
%   b     - vektor sisi kanan 2x1
%   xSol  - vektor solusi 2x1
%   judul - string judul figure

    figure;
    set(gcf, 'Name', judul, 'NumberTitle', 'off');

    % Tentukan titik tengah range plot
    if ~any(isnan(xSol))
        xMid = xSol(1);
    else
        xMid = 0;
    end
    xRange = linspace(xMid - 4, xMid + 4, 200);

    hold on;

    warna      = {'b', 'r'};
    labelGaris = {'', ''};

    for i = 1 : 2
        % Persamaan: A(i,1)*x + A(i,2)*y = b(i)
        % → y = (b(i) - A(i,1)*x) / A(i,2)
        if abs(A(i, 2)) > 1e-12
            yRange        = (b(i) - A(i, 1) * xRange) / A(i, 2);
            plot(xRange, yRange, [warna{i} '-'], 'LineWidth', 2);
            labelGaris{i} = sprintf('Pers.%d: %.4gx + %.4gy = %.4g', ...
                                     i, A(i,1), A(i,2), b(i));
        else
            % Garis vertikal: x = b(i)/A(i,1)
            xV            = b(i) / A(i, 1);
            plot([xV xV], [xMid-4, xMid+4], [warna{i} '-'], 'LineWidth', 2);
            labelGaris{i} = sprintf('Pers.%d: x = %.4g', i, xV);
        end
    end

    % Marker titik solusi
    if ~any(isnan(xSol))
        plot(xSol(1), xSol(2), 'ko', ...
             'MarkerSize', 10, 'LineWidth', 2, 'MarkerFaceColor', 'g');
        text(xSol(1), xSol(2), ...
             sprintf('  Solusi (%.4f, %.4f)', xSol(1), xSol(2)), ...
             'FontSize', 9, 'Color', 'k', 'FontWeight', 'bold');
        labelSolusi = {sprintf('Solusi (%.4f, %.4f)', xSol(1), xSol(2))};
    else
        labelSolusi = {};
    end

    hold off;

    xlabel('x_1');
    ylabel('x_2');
    title(['Visualisasi Geometri | ' judul]);
    legend([labelGaris, labelSolusi], 'Location', 'best');
    grid on;
    axis tight;
    set(gcf, 'Position', [100, 100, 600, 450]);
end
