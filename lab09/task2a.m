clear all; close all; clc;

%% Parametry
M = 256;                 % liczba wag filtru adaptacyjnego
mi_mowa = 1e-4;          % krok LMS dla mowy
mi_noise = 1e-5;         % krok LMS dla szumu
N = 500000;              % liczba próbek dla białego szumu

%% Odpowiedź impulsowa obiektu
h_real = zeros(M,1);
h_real(256) = 0.8;
h_real(121) = -0.5;
h_real(31)  = 0.1;

%% --- 1. Identyfikacja na bazie sygnału mowy ---
[x_mowa, Fs] = audioread('mowa8000.wav');
x_mowa = x_mowa(:);         % upewnij się, że kolumna
x_mowa = x_mowa - mean(x_mowa); % usunięcie składowej stałej
x_mowa = x_mowa / std(x_mowa);  % normalizacja

% Powtórz sygnał mowy, jeśli jest za krótki
if length(x_mowa) < N
    x_mowa = repmat(x_mowa, ceil(N / length(x_mowa)), 1);
    x_mowa = x_mowa(1:N);
end

N_mowa = length(x_mowa);
d_mowa = conv(x_mowa, h_real);
d_mowa = d_mowa(1:N_mowa);

h_est_mowa = zeros(M,1);
e_mowa = zeros(N_mowa,1);

for n = M:N_mowa
    x_vec = x_mowa(n:-1:n-M+1);
    y = h_est_mowa' * x_vec;
    e_mowa(n) = d_mowa(n) - y;
    h_est_mowa = h_est_mowa + mi_mowa * x_vec * e_mowa(n);
end

%% --- 2. Identyfikacja na bazie szumu białego ---
x_noise = randn(N,1);
x_noise = x_noise - mean(x_noise); % usunięcie składowej stałej
x_noise = x_noise / std(x_noise);  % normalizacja

d_noise = conv(x_noise, h_real);
d_noise = d_noise(1:N);

h_est_noise = zeros(M,1);
e_noise = zeros(N,1);

for n = M:N
    x_vec = x_noise(n:-1:n-M+1);
    y = h_est_noise' * x_vec;
    e_noise(n) = d_noise(n) - y;
    h_est_noise = h_est_noise + mi_noise * x_vec * e_noise(n);
end

%% --- Rysowanie wyników ---

% 1. Wykres dla sygnału mowy
figure;
stem(0:M-1, h_real, 'k', 'LineWidth', 1.5, 'DisplayName', 'Odpowiedź rzeczywista'); hold on;
stem(0:M-1, h_est_mowa, 'r', 'DisplayName', 'Estymacja (mowa)');
legend;
title('Estymacja odpowiedzi impulsowej – sygnał mowy');
xlabel('Próbka'); ylabel('Amplituda');
grid on;

% 2. Wykres dla szumu białego
figure;
stem(0:M-1, h_real, 'k', 'LineWidth', 1.5, 'DisplayName', 'Odpowiedź rzeczywista'); hold on;
stem(0:M-1, h_est_noise, 'b', 'DisplayName', 'Estymacja (szum)');
legend;
title('Estymacja odpowiedzi impulsowej – szum biały');
xlabel('Próbka'); ylabel('Amplituda');
grid on;

% 3. Porównanie obu estymacji na jednym wykresie (dodatkowo)
figure;
stem(0:M-1, h_real, 'k', 'LineWidth', 1.5, 'DisplayName', 'Odpowiedź rzeczywista'); hold on;
stem(0:M-1, h_est_mowa, 'r', 'DisplayName', 'Estymacja (mowa)');
stem(0:M-1, h_est_noise, 'b', 'DisplayName', 'Estymacja (szum)');
legend;
title('Porównanie estymacji odpowiedzi impulsowej');
xlabel('Próbka'); ylabel('Amplituda');
grid on;