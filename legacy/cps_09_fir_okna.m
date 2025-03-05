% cps_09_fir_okna.m
clear all; close all;

fpr = 2000;      % czestotliwosc probkowania
f0 = 100;        % czestotliwosc graniczna dla filtrow low-pass oraz high-pass
f1 = 400;        % czestotliwosc graniczna dolna dla filtrow band-pass oraz band-stop
f2 = 600;        % czestotliwosc graniczna gorna dla filtrow band-pass oraz band-stop
M = 100;         % polowa dlugosci filtra (N=2M+1)
N = 2*M + 1;     % dlugosc filtra b(n) - u nas zawsze nieparzysta
n = -M :1: M;    % indeksy wag filtra, filtr nieprzyczynowy: b(n) rozne od 0 dla n<0

% Odpowiedzi impulsowe filtrow FIR - ich wagi
hALL = zeros(1,N); hALL(M+1)=1;                          % AllPass
hLP = sin(2*pi*f0/fpr*n)./(pi*n); hLP(M+1) = 2*f0/fpr;   % LowPass f0
hHP = hALL - hLP;                                        % HighPass
hLP1 = sin(2*pi*f1/fpr*n)./(pi*n); hLP1(M+1) = 2*f1/fpr; % LowPass f1
hLP2 = sin(2*pi*f2/fpr*n)./(pi*n); hLP2(M+1) = 2*f2/fpr; % LowPass f2
hBP = hLP2 - hLP1;                                       % BandPass [f1,f2]
%hBS = ?;                                                % BandStop [f1,f2]
b = hLP;                                                 % wybierz: hLP, hHP, hBP, hBS
stem( n, b ); title('b(n)'); grid; pause
b = b .* chebwin(N,100)';                                % okno Czebyszewa o tlumieniu -100 dB
stem( n, b ); title('b(n)'); grid; pause
