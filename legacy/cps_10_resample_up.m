% cps_10_resample_up.m - nad-probkowanie (interpolacja) sygnalu
clear all; close all;

% Wejscie - parametry i sygnal wejsciowy x
K=3; M=72; N=2*M+1; Nx=1000;               % K - rzad nad-probkowania
x = sin(2*pi*(0:Nx-1)/100);                % sygnal do nad-probkowania
% [x,fs]=audioread('mowa.wav'); x=x(:,1)'; Nx = length(x);  % do dalszych testow
R=rem(Nx,K); x = x(1:end-R); Nx = Nx-R;    % korekta dlugosci dla filtracji polifazowej

% Wolne nad-probkowanie (interpolacja)
% splot wag filtra z sygnalem uzupelnionym zerami 
xz = zeros(1,K*Nx);                        % # wstawienie zer pomiedzy
xz(1:K:end) = x;                           % # probki sygnalu
h = K*fir1(N-1, 1/K, kaiser(N,12));        % projekt filtra interpolujacego                
yi = filter(h,1,xz);                       % filtracja wygladzajaca (usuwajaca zera)

figure; freqz(x,1,1000,'whole');           % spektrum DFT signalu x(n)
figure; freqz(xz,1,1000,'whole');          % spektrum DFT signalu xz(n)
figure; freqz(h,1,1000,'whole');           % spektrum DFT filtra h(n) 
figure; freqz(yi,1,1000,'whole');          % spektrum DFT signal yi(n)

n = M+1:K:K*Nx-M; ni = N:K*Nx-(K-1);
figure; plot(n,x(M/K+1:Nx-M/K),'ro-',ni-M,yi(ni),'bx'); title('x(n) and yi(n)');
err1 = max(abs(x(M/K+1:Nx-M/K)-yi(ni(1:K:end)))), pause

% Szybkie nad-probkowanie (interpolacja)
% K splotow sygnalu oryginalnego z K skladowymi polifazowymi wag filtra (co K-ta waga zaczynajac od 1,2,...,K-1)
% sygnal nie jest uzupelniony zerami 
for k=1:K
    yipp(k:K:K*Nx) = filter( h(k:K:end), 1, x);
end
err2 = max(abs(yi-yipp)), pause
