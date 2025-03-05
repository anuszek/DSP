% cps_08_iir_projekt.m
clear all; close all;

% Wymagania odnosnie filtracji cyfrowej
fpr = 2000;        % czestotliwosc probkowania
f1 = 400;          % czestotliwosc dolna filtra band-pass
f2 = 600;          % czestotliwosc gorna filtra band-pass
N  = 6;            % liczba biegunow prototypu analogowego
Rp = 3; Rs = 60;   % oscylacje (R-ripples) w [dB] w pasmie PASS i STOP

% Wymagania cyfrowe --> analogowe
f1 = 2*fpr*tan(pi*f1/fpr) / (2*pi);
f2 = 2*fpr*tan(pi*f2/fpr) / (2*pi);
w0 = 2*pi*sqrt(f1*f2);
dw = 2*pi*(f2-f1);

% Projekt filtra analogowego
[z,p,gain] = ellipap(N,Rp,Rs);        % prototyp analogowy eliptyczny dolno-przepustowy
[z,p,gain] = lp2bsMY(z,p,gain,w0,dw); % transformacja czestotliwosci NASZA: LP -> BS
    b = gain*poly(z); a = poly(p);    % zera & bieguny analogowe --> wspolczynniki [b,a]
    freqs(b,a), pause                 % odpowiedz czestotliwosciowa filtra analogowego [b,a]
% Dodaj rysunek z polozeniem zer & biegunow filtra analogowego
% Oblicz sam i pokaz odpowiedz czestotliwosciowa filtra analogowego

% Konwersja filtra analogowego na cyfrowy
[z,p,gain] = bilinearMY(z,p,gain,fpr); % funkcja biliearMY() NASZA
b = real( gain*poly(z) ); a = real( poly(p) );  % zera & bieguny cyfrowe --> wsp. [b,a]
fvtool(b,a), pause                              % wyswietlenie zaprojektowanego filtra

% Dodaj rysunek pokazujacy polozenie zer & biegunow filtra cyfrowego
% Oblicz i pokaz odpowiedz czestotliwosciowa filtra, w Matlabie H=freqz(b,a,f,fpr)
% Dokonaj filtracji wybranych sygnalow, w Matlabie y=filter(b,a,x) 
