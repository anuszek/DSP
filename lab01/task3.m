clear all; close all;

load('adsl_x.mat');

% Parametry sygnału
M = 32;  % Długość prefiksu
N = 512; % Długość bloku
K = 4;   % Liczba powtórzeń

L = length(x);
poczatki_prefiksow = zeros(1, K);

for k = 1:K
    % Indeks próbki rozpoczynającej prefiks
    idx_start = (k - 1) * (M + N) + 1;
    
    prefix = x(idx_start : idx_start + M - 1);
    
    % Obliczenie korelacji krzyżowej między prefiksem a sygnałem
    [r, lags] = xcorr(prefix, x);
    
    % Znalezienie indeksu początku prefiksu w sygnale
    [~, idx] = max(abs(r));
    poczatek_prefiksu = lags(idx);
    
    poczatki_prefiksow(k) = poczatek_prefiksu;
end

disp('Początki prefiksów:');
disp(abs(poczatki_prefiksow));

