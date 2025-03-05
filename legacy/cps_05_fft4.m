% cps_05_fft4.m

clear all; close all;
N=16;

x1 = randn(1,N);     % Dwa sygnaly
x2 = randn(1,N);
x3(1:2:2*N) = x1;    x3(2:2:2*N) = x2; 

X1 = fft(x1);        % Ich widma DFT
X2 = fft(x2);
X3 = fft(x3);

% Obliczenie dwoch widm dwoch sygnalow z uzyciem jednego FFT
x12 = x1 + j*x2;    % utworzenie sygnalu zespolonego
X12 = fft(x12);     % obliczenie jego widm DFT
X12r = real(X12);   % czesc rzeczywista wyniku
X12i = imag(X12);   % czesc urojona

% Rekonstrukcja widma X1 na podstawie widma X12
X1r(2:N) = (X12r(2:N)+X12r(N:-1:2))/2;  % uzycie symetrii Real(X1)
X1i(2:N) = (X12i(2:N)-X12i(N:-1:2))/2;  % uzycie asymetrii Imag(X1)
X1r(1) = X12r(1);
X1i(1) = 0;
X1rec = X1r + j*X1i;
error_X1 = max(abs( X1 - X1rec )), pause

% Rekonstrukcja widma X2 na podstawie widma X12
% ... do zrobienia
% Rekonstrukcja widma X3 na podstawie widm X1 oraz X2
% ... do zrobienia
