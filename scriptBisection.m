close all %tutup semua figure
clear %hapus semua variabel
clc %hapus command window

% 1. Mendefinisikan f(x) sebagai fungsi
F=@(x) 8-4.5*(x-sin(x));

% 2. Tampilkan grafik fungsi
gambar()
fplot(F,[0,5])
grid on

% 3. Tentukan nilai batas bawah (a), batas atas (b), maksimum iterasi, maksimum toleransi
a=input('tentukan nilai batas bawah (a) = ');
b=input('tentukan nilai batas atas (b) = ');
a0=a;
b0=b;
imax=100;
tol=0.0001;

Fa=F(a);
Fa0=Fa;

Fb=F(b);
Fb0=Fb;

%4. Lakukan Pencarian nilai F(x) = 0
if Fa*Fb<0
    fprintf('\n=====================================================================================\n');
    fprintf('            METODE BISEKSI (BAGI DUA)\n');
    fprintf('=======================================================================================\n');
    fprintf(' Iter |      a         |      b         |      c         |     f(c)       |   Error\n');
    fprintf('------+----------------+----------------+----------------+----------------+----------\n');
    
    % A. Lakukan iterasi
    for i = 1:imax
        xNS=(a+b)/2; %hitung solusi numerik xNS pada iterasi ke-i
        toli=(b-a)/2; %hitung toleransi iterasi ke-i
        FxNS=F(xNS);
        Fa=F(a);
        Fb=F(b);
        fprintf(' %4d | %14.8f | %14.8f | %14.8f | %14.8f | %9.5f\n', ...
            i, a, b, xNS, FxNS, toli);
        hold on
        scatter(a,Fa,50,log(i),'filled')
        scatter(b,Fb,50,log(i),'filled')
        
        if FxNS == 0
            fprintf('solusi ditemukan pada x=%11.6f\n',xNS);
            break
        end
        if toli<tol
            fprintf('toleransi iterasi ke-%d lebih kecil dari toleransi yang ditetapkan sebesar %d\n',i, tol);
            break
        end
        if i==imax
            fprintf('solusi tidak ditemukan dalam %d iterasi\n',imax);
            break
        end
        if F(a)*FxNS < 0
            b=xNS;
        else
            a=xNS;
        end
    end
    
else
    error('f(a) dan f(b) harus berbeda tanda. Periksa interval [a, b].');
end

% 4. Buat Grafik nya

scatter(xNS,FxNS,50,'dr','filled');
line([xNS xNS],[0 -20],'color',[1 0 0])
line([0 xNS],[0 0],'color',[1 0 0])


