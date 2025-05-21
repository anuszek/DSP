clear; close all; clc;

%% 1. Generowanie sygnału z dwiema harmonicznymi
fs = 8000;
t = 0:1/fs:1 - 1/fs;
A1 = -0.5; f1 = 34.2;
A2 = 1; f2 = 115.5;
dref = A1*sin(2*pi*f1*t) + A2*sin(2*pi*f2*t);

% Dodawanie szumu
noise_levels = [10, 20, 40];
d_noisy = cell(1,3);
for i = 1:3
    d_noisy{i} = awgn(dref, noise_levels(i), 'measured');
end

%% 2. Dobór parametrów filtra (M i mi)
% Parametry do przetestowania
M_values = [1, 10, 3];         % Różne długości filtra (skrajne i optymalny)
mi_values = [0.01, 2.0, 0.5];  % Różne wartości współczynnika adaptacji (skrajne i optymalny)
use_NLMS = true;               % Wybór algorytmu NLMS

% Testowanie dla różnych wartości parametrów
SNRdB_results = zeros(length(M_values), 1);
d = d_noisy{2};  % Używamy szumu o SNR=20dB
output_signals = cell(length(M_values), 1);
error_signals = cell(length(M_values), 1);
filter_weights = cell(length(M_values), 1);

% Przetwarzanie dla każdego zestawu parametrów
for param_idx = 1:length(M_values)
    M = M_values(param_idx);
    mi = mi_values(param_idx);

    % Przygotowanie wejścia
    x = [d(1), d(1:end-1)];

    % Inicjalizacja zmiennych
    y = zeros(length(x), 1);
    e = zeros(length(x), 1);
    bx = zeros(M, 1);
    h = zeros(M, 1);

    % Główna pętla filtra
    for n = 1:length(x)
        bx = [x(n); bx(1:M-1)];
        y(n) = h' * bx;
        e(n) = d(n) - y(n);

        % Aktualizacja wag
        if use_NLMS
            h = h + mi * e(n) * bx / (bx'*bx + 1e-6); % NLMS
        else
            h = h + mi * e(n) * bx; % LMS
        end
    end

    % Zapisanie wyników
    output_signals{param_idx} = y;
    error_signals{param_idx} = e;
    filter_weights{param_idx} = h;

    % Obliczenie SNR
    error = dref(:) - y(:); % Zapewnienie, że oba wektory są w tym samym formacie kolumnowym
    SNRdB_results(param_idx) = 10*log10(mean(dref(:).^2)/mean(error.^2));
end

% Wybór optymalnych parametrów na podstawie SNR
[best_snr, best_idx] = max(SNRdB_results);
fprintf('Najlepsze SNR: %.2f dB dla M=%d, mi=%.2f\n', best_snr, M_values(best_idx), mi_values(best_idx));

% Wykresy porównawcze parametrów
figure;
subplot(3,1,1);
plot(t, dref, 'b', t, d, 'r', t, output_signals{1}, 'g');
title(sprintf('M=%d, mi=%.2f, SNR=%.2f dB (za mały filtr, za wolna adaptacja)', M_values(1), mi_values(1), SNRdB_results(1)));
legend('Oryginał', 'Zaszumiony', 'Odszumiony');
xlabel('Czas [s]'); ylabel('Amplituda');

subplot(3,1,2);
plot(t, dref, 'b', t, d, 'r', t, output_signals{2}, 'g');
title(sprintf('M=%d, mi=%.2f, SNR=%.2f dB (za duży filtr, za szybka adaptacja)', M_values(2), mi_values(2), SNRdB_results(2)));
legend('Oryginał', 'Zaszumiony', 'Odszumiony');
xlabel('Czas [s]'); ylabel('Amplituda');

subplot(3,1,3);
plot(t, dref, 'b', t, d, 'r', t, output_signals{3}, 'g');
title(sprintf('M=%d, mi=%.2f, SNR=%.2f dB (optymalne parametry)', M_values(3), mi_values(3), SNRdB_results(3)));
legend('Oryginał', 'Zaszumiony', 'Odszumiony');
xlabel('Czas [s]'); ylabel('Amplituda');

% Ustaw parametry do dalszej części kodu
M = M_values(3);          % Długość filtra
mi = mi_values(3);        % Współczynnik szybkości adaptacji NLMS

%% 3. Sygnał SFM
fc = 1000; delta_f = 500; fm = 0.25;
beta = delta_f/fm;
dref_sfm = cos(2*pi*fc*t + beta*sin(2*pi*fm*t));

% Przetwarzanie dla SFM
d_sfm_noisy = awgn(dref_sfm, 20, 'measured');
x_sfm = [d_sfm_noisy(1), d_sfm_noisy(1:end-1)];

% Inicjalizacja zmiennych dla SFM
y_sfm = []; h_sfm = zeros(M,1); bx_sfm = zeros(M,1);

for n = 1:length(x_sfm)
    bx_sfm = [x_sfm(n); bx_sfm(1:M-1)];
    y_sfm(n) = h_sfm' * bx_sfm;
    e_sfm = d_sfm_noisy(n) - y_sfm(n);

    if use_NLMS
        h_sfm = h_sfm + mi * e_sfm * bx_sfm / (bx_sfm'*bx_sfm + 1e-6);
    else
        h_sfm = h_sfm + mi * e_sfm * bx_sfm;
    end
end

% Obliczanie SNRdB dla SFM
error_sfm = dref_sfm - y_sfm;
SNRdB_sfm = 10*log10(mean(dref_sfm.^2)/mean(error_sfm.^2));

%% 4. Sygnał mowy
[mowa, fs_mowa] = audioread('mowa8000.wav');
mowa = mean(mowa, 2);                  % Konwersja na mono
mowa = resample(mowa, fs, fs_mowa);    % Dostosowanie częstotliwości
mowa = mowa(1:fs);                     % Przycięcie do 1 sekundy
mowa = mowa(:);                        % Wymuszenie orientacji kolumnowej

d_mowa_noisy = awgn(mowa, 20, 'measured');
x_mowa = [d_mowa_noisy(1); d_mowa_noisy(1:end-1)];

% Parametry do przetwarzania mowy
M = 4;                          % Długość filtra
mi = 0.2;                       % Współczynnik szybkości adaptacji NLMS
use_NLMS = true;

% Inicjalizacja dla mowy
y_mowa = zeros(length(x_mowa), 1);     % Prealokacja
h_mowa = zeros(M, 1);
bx_mowa = zeros(M, 1);

for n = 1:length(x_mowa)
    bx_mowa = [x_mowa(n); bx_mowa(1:M-1)];
    y_mowa(n) = h_mowa' * bx_mowa;
    e_mowa = d_mowa_noisy(n) - y_mowa(n);

    if use_NLMS
        h_mowa = h_mowa + mi * e_mowa * bx_mowa / (bx_mowa'*bx_mowa + 1e-6);
    else
        h_mowa = h_mowa + mi * e_mowa * bx_mowa;
    end
end

y_mowa = y_mowa(:);                    % Konwersja na kolumnę
error_mowa = mowa(1:length(y_mowa)) - y_mowa;
SNRdB_mowa = 10*log10(mean(mowa.^2)/mean(error_mowa.^2));

%% Wykresy
% Dla sygnału harmonicznego
figure;
subplot(2,1,1);
plot(t, dref, 'b', t, d_noisy{2}, 'r', t, y, 'g');
legend('Oryginał', 'Zaszumiony', 'Odszumiony');
title('Porównanie sygnałów harmonicznych');
xlabel('Czas [s]'); ylabel('Amplituda');

subplot(2,1,2);
[H, f] = freqz(h, 1, 1024, fs);
plot(f, 20*log10(abs(H)));
title('Charakterystyka amplitudowa filtru (harmoniczne)');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda [dB]');

% Dla sygnału SFM
figure;
subplot(2,1,1);
plot(t, dref_sfm, 'b', t, d_sfm_noisy, 'r', t, y_sfm, 'g');
legend('Oryginał SFM', 'Zaszumiony SFM', 'Odszumiony SFM');
title('Porównanie sygnałów SFM');
xlabel('Czas [s]'); ylabel('Amplituda');

subplot(2,1,2);
[H_sfm, f_sfm] = freqz(h_sfm, 1, 1024, fs);
plot(f_sfm, 20*log10(abs(H_sfm)));
title('Charakterystyka amplitudowa filtru (SFM)');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda [dB]');

% Dla sygnału mowy
figure;
subplot(2,1,1);
plot(t, mowa, 'b', t, d_mowa_noisy, 'r', t, y_mowa, 'g');
legend('Oryginał mowa', 'Zaszumiony mowa', 'Odszumiony mowa');
title('Porównanie sygnału mowy');
xlabel('Czas [s]'); ylabel('Amplituda');

subplot(2,1,2);
[H_mowa, f_mowa] = freqz(h_mowa, 1, 1024, fs);
plot(f_mowa, 20*log10(abs(H_mowa)));
title('Charakterystyka amplitudowa filtru (mowa)');
xlabel('Częstotliwość [Hz]'); ylabel('Amplituda [dB]');

%% Funkcja pomocnicza do obliczania SNR
function snr = calculate_SNR(original, denoised)
error = original - denoised;
signal_power = mean(original.^2);
noise_power = mean(error.^2);
snr = 10*log10(signal_power/noise_power);
end