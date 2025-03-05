% cps_11_diff.m - rozniczkowanie sygnalu z uzyciem filtra FIR
clear all; close all;

% Projekt wag filtra rozniczkujacego FIR
M=50; N=2*M+1; n=-M:M; h=cos(pi*n)./n; h(M+1)=0; % h=(1-cos(pi*n))./(pi*n); h(M+1)=0; % Hilbert
h = h .* kaiser(N,10)';
%h = 1/12 * [-1, 8, 0, -8, 1]; M=2; N=2*M+1; n = -M:M; % 1/2*[-1 0 1]
stem(n,h); title('h(n)'); grid; pause

% Weryfikacja odpowiedzi filtra: amplitudowej i fazowej
fs = 2000; f = 0:1:fs/2;        % czestotliwosc probkowania [Hz], wybrane czestotliwosci 
z = exp(-j*2*pi*f/fs);          % zmienna "z" transformacji Z (dokladniej z^(-1))
H = polyval(h(end:-1:1),z);     % odpowiedz czestotliwosciowa
% H = freqz(h,1,f,fs);          % funkcja Matlaba
figure; plot(f,abs(H)); xlabel('f [Hz]'); title('|H(f)|'); grid;
figure; plot(f,unwrap(angle(H))); xlabel('f [Hz]'); title('angle(H(f)) [rad]'); grid;
figure; plot(f,angle(exp(j*2*pi*f/fs*M).*H)); xlabel('f [Hz]'); title('angle(H(f)) [rad]'); grid;

% Filtracja - rozniczkowanie sygnalu
Nx=400; n=0:Nx-1; dt=1/fs; t=dt*n;
fx=50; x=sin(2*pi*fx*t);
y=filter(h,1,x);
nx=M+1:Nx-M; ny=2*M+1:Nx;
figure; plot(nx,x(nx),'ro-',nx,y(ny),'bo-'); title('x(n), y(n)'); grid; pause
