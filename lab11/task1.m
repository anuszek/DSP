close all; clear all; clc;

[x, Fs] = audioread('DontWorryBeHappy.wav');
x = double(x);

if size(x,2) > 1
    x = mean(x, 2); % stereo → mono
end

a = 0.9545;
d = x - a * [0; x(1:end-1)];

% --- KODER DPCM ---
d = x - a * [0; x(1:end-1)]; % różnica predykcji

% --- KWANTYZACJA ---
dq_quant = quantize_signal(d); % kwantyzacja do 16 poziomów
dq_no_quant = d; % wersja bez kwantyzacji

% --- DEKODER DPCM ---
y_no_quant = zeros(size(x));
y_quant = zeros(size(x));

for n = 2:length(x)
    y_no_quant(n) = dq_no_quant(n) + a * y_no_quant(n-1);
    y_quant(n) = dq_quant(n) + a * y_quant(n-1);
end

% --- PORÓWNANIE ---
figure(1);
subplot(2,1,1);
plot(x, 'b'); hold on; plot(y_no_quant, 'r'); 
title('DPCM bez kwantyzacji'); legend('x(n)', 'y(n)');

subplot(2,1,2);
plot(x, 'b'); hold on; plot(y_quant, 'r'); 
title('DPCM z kwantyzacją (16 poziomów)'); legend('x(n)', 'y(n)');
soundsc(y_quant,Fs)

% --- BŁĘDY ---
mse_no_quant = mean((x - y_no_quant).^2);
mse_quant = mean((x - y_quant).^2);
disp(['MSE bez kwantyzacji: ', num2str(mse_no_quant)]);
disp(['MSE z kwantyzacją: ', num2str(mse_quant)]);

N = length(x);
y = zeros(size(x));
prev_y = 0;
prev_x = 0;

% ADAPTIVE quantizer params
Delta = 0.01; % initial step size
beta = 1.2;   % increase factor
alpha = 0.9;  % decrease factor (łagodniej!)
max_delta = 1;
min_delta = 1e-3;

for n = 1:N
    % prediction
    pred = a * prev_x;
    d = x(n) - pred;
    
    % quantization
    q_index = round(d / Delta);
    dq = q_index * Delta;
    
    % update step size adaptively
    if abs(q_index) > 2  % zmiana przy dużych błędach
        Delta = min(Delta * beta, max_delta);
    else
        Delta = max(Delta * alpha, min_delta);
    end
    
    % reconstruction
    y(n) = dq + a * prev_y;
    
    % update states
    prev_x = x(n);
    prev_y = y(n);
end

% plot comparison
figure;
plot(x, 'b'); hold on; plot(y, 'r'); legend('x(n)', 'y(n)');
title('ADPCM Reconstruction');

% save to file
audiowrite('output_adpcm.wav', y / max(abs(y)), Fs);

% Funkcja kwantyzacji
function dq = quantize_signal(d)
    levels = 16;
    sigma = std(d);
    dmax = 3 * sigma;
    dmin = -3 * sigma;
    d_clip = max(min(d, dmax), dmin); % przycięcie do ±3σ
    step = (dmax - dmin) / (levels - 1);
    dq = round((d_clip - dmin) / step) * step + dmin;
end