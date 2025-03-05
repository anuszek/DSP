% cps_09_fir_idft.m
clear all; close all;

% Parametry
fpr = 2000;                               % czestotliwosc probkowania (Hz)
f0=100; f1=400; f2=600;                   % czestotliwosci graniczne
M = 100;                                  % polowa dlugosci filtra
K = 4;                                    % nadprobkowanie w dziedzinie czestotliwosci
N = 2*M + 1;                              % dlugosc filtra b(n) - zawsze nieparzysta
n = -M :1: M;                             % indeksy wag filtra
NK = N*K; if(rem(NK,2)==1) NK=NK+1; end   % po nadprobkowaniu w czestotliwosci
df = fpr/NK; f = df*(0 : NK/2);            % czestotliwosci
H0 = zeros(1,NK/2+1);                     % inicjalizacja
H1 = ones(1,NK/2+1);                      % inicjalizacja
% Low-Pass - dolnoprzepustowy
ind = find( f<=f0 );     
HLP = H0; HLP(ind) = ones(1,length(ind)); HLP(ind(end))=0.5;
% High-Pass - gornoprzepustowy
ind = find( f>=f0 );
HHP = H0; HHP(ind) = ones(1,length(ind)); HLP(ind(1))=0.5;
% Band-Pass oraz Band-Stop - pasmo-woprzepustowy i pasmowo-zaporowy
ind1 = find( f< f1 );    
ind2 = find( f<=f2 );
ind  = find( ind2 > ind1(end) );
HBP = H0; HBP(ind) = ones(1,length(ind));  HBP(ind(1))=0.5; HBP(ind(end))=0.5; 
% HBS = ?  % to jest Twoje zadanie

% Nasz wybor: LP, HP, BP, BS
H = HBP;                                        % wybor: LP, HP, BP, BS
H(NK:-1:NK/2+2) = H(2:NK/2);                    % odbicie symetryczne

h = ifft( H );                                  % odwrotne DFT
b = [ h(M+1:-1:2) h(1:M+1) ];                   % wybor 2M+1 srodkowych wag
%b = b .* chebwin(N,100)';                      % opcjonalne okienkowanie wag
figure; stem(n,b); title('b(n)'); grid; pause   % rysunek wag
