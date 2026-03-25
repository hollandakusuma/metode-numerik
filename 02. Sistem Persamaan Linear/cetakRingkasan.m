function cetakRingkasan(kasus, ukuran, isSingular, x)
% CETAKRINGKASAN  Mencetak satu baris ringkasan hasil ke layar
%
% Input:
%   kasus      - nomor kasus (integer)
%   ukuran     - string ukuran sistem, misal '3x3'
%   isSingular - true jika matriks singular
%   x          - vektor solusi

    if isSingular
        status = 'YA';
        solStr = 'Tidak ada';
    else
        status = 'TIDAK';
        % Bangun string solusi secara manual (tanpa strjoin agar kompatibel)
        solStr = '';
        for k = 1 : length(x)
            solStr = [solStr sprintf('%.4f', x(k))]; %#ok<AGROW>
            if k < length(x)
                solStr = [solStr ', ']; %#ok<AGROW>
            end
        end
        if length(solStr) > 28
            solStr = [solStr(1:25) '...'];
        end
    end

    fprintf('  %-8d  %-10s  %-12s  %s\n', kasus, ukuran, status, solStr);
end
