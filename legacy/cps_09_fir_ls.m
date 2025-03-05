% cps_09_fir_ls.m
clear all; close all;

% Parametry  
fpr = 2000;                   % czestotliwosc probkowania (Hz)
f0 = 100;                     % czestotliwosc graniczna
M = 100;                      % polowa dlugosci filtra, N=2M+1
K = 4;                        % nadprobkowanie w dziedzinie czestotliwosci
% P punktow zadanej ch-ki amplitudowej Ad() dla czestotliwosci katowych 2*pi*p/P, p=0...P-1
P = K*2*M;                    % liczba punktow ch-ki amplitudowej (parzysta; P >= N=2M+1)
L1 = floor(f0/fpr*P),         % liczba pierwszych punktow o wzmocnieniu 1
Ad = [ ones(1,L1) 0.5 zeros(1,P-(2*L1-1)-2) 0.5 ones(1,L1-1)]; 
Ad = Ad'; 
% Wybor wspolczynnikow wagowych w(p) optymalizacji, p=0...P-1, dla pasm Pass/Transit/Stop
wp = 1;                      %  wagi dla PassBand
wt = 1;                      %  wagi dla TransientBand
ws = 10000;                  %  wagi dla StopBand
w = [ wp*ones(1,L1) wt ws*ones(1,P-(2*L1-1)-2) wt wp*ones(1,L1-1) ]; 
W = zeros(P,P);              % 
for p=1:P                    %  macierz z wagami optymalizacji na glownej przekatnej
    W(p,p)=w(p);             %
end                          %
% Znajdz macierz F, bedaca rozwiazaniem rownania macierzowego  W*F*h = W*(Ad + err) 
F = [];
n = 0 : M-1; 
for p = 0 : P-1
    F = [ F; 2*cos(2*pi*(M-n)*p/P) 1 ]; 
end
% Znajdz wagi h(n), minimalizujace blad LS sum( (W*F*h - W*Ad).^2 )
% h = pinv(W*F)*(W*Ad);      % metoda #1
h = (W*F)\(W*Ad);            % metoda #2
b = [ h; h(M:-1:1) ]';       % odbicie symetryczne
%b = b .* chebwin(N,100)';   % opcjonalne zastosowanie dowolnej funkcji okna 
figure; stem(-M:M,b); title('b(n)'); grid; pause   % rysunek
