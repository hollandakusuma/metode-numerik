function Yint = linearSpline(x, y, Xint)
% LinearSpline calculates interpolation using linear splines.
% Input variables:
% x    A vector with the coordinates x of the data points.
% y    A vector with the coordinates y of the data points.
% Xint The x coordinate of the interpolated point.
% Output variable:
% Yint The y value of the interpolated point.

n = length(x);

% Mencari interval yang memuat Xint
for i = 2:n
    if Xint < x(i)
        break
    end
end

% Menghitung Yint dengan persamaan (6.65)
% Persamaan ini merupakan bentuk lain dari interpolasi linier antara
% titik (x(i-1), y(i-1)) dan (x(i), y(i))
Yint = (Xint - x(i)) * y(i-1) / (x(i-1) - x(i)) + (Xint - x(i-1)) * y(i) / (x(i) - x(i-1));

end