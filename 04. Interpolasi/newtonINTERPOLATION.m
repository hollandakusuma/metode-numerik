function Yint = newtonINTERPOLATION(x, y, Xint)
% NewtonsINT fits a Newtons polynomial to a set of given points and
% uses the polynomial to determines the interpolated value of a point.
% Input variables:
% x    A vector with the x coordinates of the given points.
% y    A vector with the y coordinates of the given points.
% Xint The x coordinate of the point to be interpolated.
% Output variable:
% Yint The interpolated value of Xint.

n = length(x);
a(1) = y(1);

% Menghitung finite divided differences kolom pertama
for i = 1:n - 1
    divDIF(i,1) = (y(i+1) - y(i)) / (x(i+1) - x(i));
end

% Menghitung divided differences tingkat kedua dan seterusnya
for j = 2:n - 1
    for i = 1:n - j
        divDIF(i,j) = (divDIF(i+1, j-1) - divDIF(i, j-1)) / (x(j+i) - x(i));
    end
end

% Memasukkan koefisien a2 sampai an ke dalam vektor a
for j = 2:n
    a(j) = divDIF(1, j - 1);
end

% Menghitung nilai interpolasi Yint menggunakan skema Horner-like
Yint = a(1);
xn = 1;
for k = 2:n
    xn = xn * (Xint - x(k - 1));
    Yint = Yint + a(k) * xn;
end

end