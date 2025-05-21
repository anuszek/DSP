clear all; close all; clc;

%% Parametry sygnału
Fs = 192e3;                          % Częstotliwość próbkowania (Hz)
t = 0:1/Fs:1;                        % Wektor czasu (1 sekunda)
f_pilot = 19e3;                      % Częstotliwość pilota (Hz)

%% 1. Sygnał pilota o stałej częstotliwości
pilot = sin(2*pi*f_pilot*t);         % Sygnał referencyjny (czysty pilot)

%% 2. Sygnał pilota z wolno zmieniającą się częstotliwością (±10 Hz, fm=0.1 Hz)
f_deviation = 10;                    % Maksymalne odchylenie częstotliwości (Hz)
fm = 0.1;                            % Częstotliwość modulacji (Hz)
f_pilot_var = f_pilot + f_deviation * sin(2*pi*fm*t);  % Chwilowa częstotliwość
pilot_var = sin(2*pi * cumsum(f_pilot_var)/Fs);       % Całkowanie fazy

%% 3. Test PLL dla różnych poziomów szumu AWGN
SNRs = [0, 5, 10, 20];               % Poziomy SNR do testu
alpha = 1e-2;                        % Współczynnik pętli PLL (filtr)
beta = alpha^2 / 4;                  % Drugi współczynnik pętli

figure;

for k = 1:length(SNRs)
    %% Dodanie szumu AWGN
    noisy = awgn(pilot, SNRs(k), 'measured');  % Pilot z szumem

    %% Inicjalizacja PLL
    theta = zeros(1, length(t) + 1);  % Faza oscylatora
    freq = 2*pi*f_pilot/Fs;           % Początkowa częstotliwość (rad/sample)

    %% Pętla PLL / PLL loop
    for n = 1:length(noisy)
        % Błąd fazy (detektor fazy)
        perr = -noisy(n) * sin(theta(n));  % Mnożnik fazowy

        % Aktualizacja fazy i częstotliwości
        theta(n+1) = theta(n) + freq + alpha * perr;  % Integrator fazy
        freq = freq + beta * perr;                    % Pętla sprzężenia zwrotnego
    end

    %% Obliczenie błędu fazy
    true_phase = 2*pi*f_pilot/Fs * (0:length(t)-1);  % Idealna faza
    pll_phase = theta(1:end-1);                      % Wyjście PLL (pominięcie ostatniej próbki)
    phase_err = wrapToPi(pll_phase - true_phase);     % Błąd fazy (zawinięty do [-π, π])

    %% Wykres błędu fazy
    subplot(length(SNRs), 1, k);
    plot(t, phase_err);
    title(['Błąd fazy PLL (SNR = ', num2str(SNRs(k)), ' dB)']);
    xlabel('Czas [s] / Time [s]');
    ylabel('Błąd [rad] / Error [rad]');
    grid on;

    %% Pomiar szybkości zbieżności
    threshold = 0.1;  % Próg zbieżności (rad)
    converged_samples = find(abs(phase_err) < threshold, 1, 'first');
    if ~isempty(converged_samples)
        fprintf('SNR=%d dB: PLL zbiega się po %d próbkach (%.2f ms)\n', ...
            SNRs(k), converged_samples, converged_samples/Fs*1000);
    else
        fprintf('SNR=%d dB: PLL nie zbiega się w wyznaczonym czasie\n', SNRs(k));
    end
end

figure;

%% Dodatkowy test: śledzenie pilota o zmiennej częstotliwości
noisy_var = awgn(pilot_var, 20, 'measured');  % FM pilot z szumem (SNR=20 dB)

% Inicjalizacja PLL dla sygnału FM
theta_var = zeros(1, length(t) + 1);
freq_var = 2*pi*f_pilot/Fs;

% Pętla PLL
for n = 1:length(noisy_var)
    perr_var = -noisy_var(n) * sin(theta_var(n));
    theta_var(n+1) = theta_var(n) + freq_var + alpha * perr_var;
    freq_var = freq_var + beta * perr_var;
end

% Obliczenie błędu częstotliwości
instantaneous_freq = diff(theta_var) * Fs / (2*pi);  % Chwilowa częstotliwość PLL
freq_err = instantaneous_freq(1:end-1) - f_pilot_var(1:end-1); % Błąd śledzenia

plot(t(1:end-1), freq_err);
title('Błąd śledzenia częstotliwości (FM pilot, SNR=20 dB)');
xlabel('Czas [s] / Time [s]');
ylabel('Błąd częstotliwości [Hz] / Frequency error [Hz]');
grid on;