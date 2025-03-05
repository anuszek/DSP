% cps_07_analog_butter.m
clear all; close all;

N = 5;                                   % liczba biegunow transmitancji
f0 = 100;                                % czestotliwosc 3dB (odciecia) filtra dolnoprzepustowego
alpha = pi/N;                            % kat "kawalka tortu" (okregu)
beta  = pi/2 + alpha/2 + alpha*(0:N-1);  % katy kolejnych biegunow transmitancji
R = 2*pi*f0;                             % promien okregu
p = R*exp(j*beta);                       % bieguny transmitancji lezace na okregu
z = []; wzm = prod(-p);                  % LOW-PASS:  brak zer tramsitancji, wzmocnienie
%z = zeros(1,N); wzm = 1;                % HIGH-PASS: N zer transmitancji, wzmocnienie
b = wzm*poly(z); a=poly(p);              % [z,p] --> [b,a]
b = real(b);      a=real(a);             %

% ... kontynuacja csp_07_analog_intro.m

figure; plot(real(z),imag(z),'bo', real(p),imag(p),'r*'); grid;
title('Zera (o) i Bieguny (*)'); xlabel('Real()'); ylabel('Imag()'); pause

% Weryfikacja odpowiedzi (charakterystyki) filtra: amplitudowej fazowej, impulsowej, skokowej
f = 0 : 0.1 : 1000;                % czestotliwosc w hercach
w = 2*pi*f;                        % czestotliwosc katowa, pulsacja
s = j*w;                           % zmienna transformacji Laplace'a
H = polyval(b,s) ./ polyval(a,s);  % h(s) --> H(f) dla s=j*w: iloraz dwoch wielomianow
figure; plot(f,20*log10(abs(H))); xlabel('f [Hz]'); title('|H(f)| [dB]'); grid; pause
figure; plot(f,unwrap(angle(H))); xlabel('f [Hz]'); title('angle(H(f)) [rad]'); grid; pause
figure; impulse(b,a); pause        % odpowiedz filtra na pobudzenie impulsowe (z Control Toolbox)
figure; step(b,a); pause           % odpowiedz filtra na pobudzenie skokowe (z Control Toolbox)
