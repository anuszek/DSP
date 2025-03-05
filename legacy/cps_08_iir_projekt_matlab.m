% cps_08_iir_projekt_matlab.m
clear all; close all;

% Wymagania odnosnie filtracji cyfrowej
fpr = 2000;        % czestotliwosc probkowania
f1 = 400;          % czestotliwosc dolna filtra band-pass
f2 = 600;          % czestotliwosc gorna filtra band-pass
N  = 6;            % liczba biegunow prototypu analogowego
Rp = 3; Rs = 60;   % oscylacje (R-ripples) w [dB] w pasmie PASS i STOP

% 1) Wymagania cyfrowe --> analogowe
f1 = 2*fpr*tan(pi*f1/fpr) / (2*pi);
f2 = 2*fpr*tan(pi*f2/fpr) / (2*pi);
w0 = 2*pi*sqrt(f1*f2);
dw = 2*pi*(f2-f1);

% Sekwencja przeksztalcen w Matlabie
[z,p,gain] = ellipap(N,Rp,Rs);       % 2) projekt prototypu analogowego (zawsze LP, w0=1)
[b,a] = zp2tf(z,p,gain);             % 3) [z,p] --> [b,a]: pierwiastki --> wsp. wielomianów
[b,a] = lp2bs(b,a,w0,dw);            % 4) LP --> BS: transfomacja czestotliwosci Matlaba
figure; freqs(b,a), pause            %    pokaż |H(f)| filtra analogowego [b,a]
[b,a] = bilinear(b,a,fpr);           % 5) H(s) --> H(z): analogowy --> cyfrowy
figure; fvtool(b,a), pause           %    pokaż |H(f)| zaprojektowanego filtra cyfrowego

% Dodaj rysunek pokazujacy polozenie zer & biegunow filtra cyfrowego
% Oblicz i pokaz odpowiedz czestotliwosciowa filtra, w Matlabie H=freqz(b,a,f,fpr)
% Dokonaj filtracji wybranych sygnalow, w Matlabie y=filter(b,a,x) 
