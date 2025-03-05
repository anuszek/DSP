% cps_06_fftapp1_start.m
clear all; close all;        % "mycie rak"

fpr = 1000;                  % czestotliwosc probkowania (Hz)
N  = 100;                    % liczba probek sygnalu, 100 lub 1000
dt=1/fpr; t=dt*(0:N-1);      % chwile probkowania sygnalu, os czasu

% Signal
f0=50; x = sin(2*pi*f0*t);   % sygnal o czestotliwosciach f0 = 50,100,125,200 Hz
figure; plot(t,x,'bo-'); xlabel('t [s]'); title('x(t)'); grid; pause

% FFT spectrum
X = fft(x);                  % FFT
f = fpr/N *(0:N-1);          % os czestotliwosci 
figure; plot(f,1/N*abs(X),'bo-'); xlabel('f [Hz]'); title('|X(k)|'); grid; pause
figure; plot(f(1:N/2+1),2/N*abs(X(1:N/2+1)),'bo-'); xlabel('f [Hz]'); title('|X(k)|'); grid; pause

% ... kontynuacja programu - część 2
% Interpolacja widma FFT z okienkowaniem sygnalu
K = 10;                   % rzad interpolacji
w1 = rectwin(N);          % okno prostokatne
w2 = chebwin(N,100);      % okno Czebyszewa
w = w1;                   % wybor okna: w1, w2, ...
x = x.*w';                % okienkowanie sygnalu
X  = fft(x,N);            % bez dolaczenia zer na koncu sygnalu
Xz = fft(x,K*N);          % z zerami; Xz = fft([x,zeros(1,(K-1)*N)])/sum(w);
fz = fpr/(K*N)*(0:K*N-1); % os czestotliwosci
figure                    %
plot(f,20*log10(abs(X)/sum(w)),'bo-',fz,20*log10(abs(Xz)/sum(w)),'r.-','MarkerFaceColor','b');
xlabel('f (Hz)'); title('Zoomowanie widma DFT z uzyciem FFT'); grid; pause

