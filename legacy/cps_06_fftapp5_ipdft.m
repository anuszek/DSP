% sps_06_fftapps5_ipdft.m  - interpolowane DFT/FFT
clear all; close all;

% Sygnal testowy
N=256; fs=100;             % liczba probek, czestotliwosc probkowania [Hz]
Ax=6; dx=0.5; fx=4; px=3;  % amplituda, tlumienie, czestotliwosc, faza
dt=1/(fs); t=(0:N-1)*dt;   % chwile probkowania
x = Ax*exp(-dx*t).*cos(2*pi*fx*t+px); figure; plot(t,x); pause % generacja sygnalu

% Interpolowane DFT dla maksimum wartosci bezwzglednej widma 
Xw = fft(x); figure; plot(abs(Xw)), pause  % obliczenie DFT/FFT
[Xabs, ind] = max(abs(Xw(1:round(N/2))));  % znalezienie maksimum i jego polozenia
km1 = ind-1; k=ind; kp1 = ind+1;           % trzy probki w otoczeniu maksimum
dw = 2*pi/N; 	           % krok czestotliwosci w DFT
wkm1= (km1-1)*dw;	       % czestotliwosc katowa dla indeksu k-1
wk  = (k  -1)*dw;	       % czestotliwosc katowa dla indeksu k
wkp1= (kp1-1)*dw;	       % czestotliwosc katowa dla indeksu k+1
R = ( Xw(km1)-Xw(k) )/( Xw(k)-Xw(kp1) );                       % eq.()
r = ( -exp(-j*wk)+exp(-j*wkm1) )/( -exp(-j*wkp1)+exp(-j*wk) ); % eq.()
lambda = exp(j*wk)*(r-R)/( r*exp(-j*2*pi/N)-R*exp(j*2*pi/N) ); % eq.()
we = imag(log(lambda));    % obliczona czestotliwosc katowa
de = -real(log(lambda));   % obliczone tlumienie

fe = we*fs/(2*pi);         % cz. katowa --> czestotliwosc
de = de*fs;                % znormalizowane tlumienie (de/fs) --> tlumienie (de)

if round(1e6*R)==-1e6      % probkowanie KOHERENTNE, dx=0
   Ae = 2*abs(Xw(k))/N;    % obliczona amplituda
   pe = angle(Xw(k));      % obliczona faza
else                       % probkowanie NIEKOHERENTNE
   c = (1-lambda^N)/(1-lambda*exp(-j*wk));                     % eq.()
   c = 2*Xw(k)/c;                                              % eq.()
   Ae = abs(c);            % obliczona amplituda
   pe = angle(c);          % obliczona faza
end

result = [ Ae, de, fe, pe ],                      % wyniki
errors = [ Ae-Ax, de-dx, fe-fx, pe-px ], pause    % bledy
