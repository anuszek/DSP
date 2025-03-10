clear all; clc;

load('adsl_x.mat'); %sygnal se wczytuje z pliku

M = 32;%M to M ostatnich z N
N = 512;

prefix = x(end-M+1:end); %no wlasnie

[correlation, lags] = xcorr(x, prefix);

figure;
plot(lags, correlation);
title('Korelacja wzajemna między sygnałem a prefiksem (xcorr)');
xlabel('Przesunięcie');
ylabel('Korelacja');

threshold = max(correlation) * 0.99; %prog
poczatki_prefiksow = find(correlation > threshold) - M + 1;%xd nie wiem jak to nazwac po ang
disp('Początki prefiksów (xcorr):');
disp(poczatki_prefiksow);

correl = MyCorrelation(x, prefix);

figure;
plot(-(length(correl)-1)/2:(length(correl)-1)/2, correl);
title('Korelacja wzajemna między sygnałem a prefiksem (MyCorrelation)');
xlabel('Przesunięcie'); ylabel('Korelacja');

function [correlation] = MyCorrelation(x, y)
    lenX = length(x);
    lenY = length(y);
    correlation = zeros(1, lenX+lenY-1);
    for k = 1:(lenX+lenY-1)
        sum = 0;
        for l = max(1, k+1-lenY):min(k, lenX)
            sum = sum + x(l) * y(k-l+1);
        end
        correlation(k) = sum;
    end
end