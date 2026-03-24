function str = statusStr(isConverged)
% Mengembalikan string status konvergensi
    if isConverged
        str = 'Konvergen';
    else
        str = 'Divergen';
    end
end
