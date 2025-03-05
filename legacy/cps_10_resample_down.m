% csp_10_resample_down.m - pod-probkowanie (decymacja) sygnalu
clear all; close all;

% Wejscie - parametry oraz sygnal wejsciowy x
L=4; M=50; N=2*M+1; Nx=1000;                   % L - rzad pod-probkowania
x = sin(2*pi*(0:Nx-1)/50); plot(x); pause      % sygnal do pod-probkowania
% [x,fs]=audioread('muzyka.wav'); x=x(:,1)'; Nx = length(x);  % do dalszych testow
R=rem(Nx,L); x = x(1:end-R); Nx = Nx-R;        % korekta dlugosci dla filtracji polifazowej

% Wolne pod-probkowanie (decymacja)
% jeden splot wag filtra z probkami sygnalu, po nim reduktor 
g = fir1(N-1, 1/L - 0.1*(1/L),kaiser(N,12));  % projekt filtra decymatora
y = filter(g,1,x);                            % filtracja
yd = y(1:L:end);                              % L-krotny reduktor

n = M+1:Nx-M; nd = (N-1)/L+1:Nx/L;
figure; plot(n,x(n),'ro-',n(1:L:end),yd(nd),'bx'); title('x(n) and yd(n)');
err1 = max(abs(x(n(1:L:end))-yd(nd))), pause

% Szybkie polifazowe pod-probkowanie (decymacja)
% L splotow skladowych PP oryginalnego sygnalu i oryginalnych wag filtra
% probki usuwane nie sa obliczane 
x = [ zeros(1,L-1) x(1:end-(L-1)) ];
ydpp = zeros(1,Nx/L);
for k=1:L
    ydpp = ydpp + filter( (g(k:L:end)), 1, x(L-k+1:L:end) );
end
err2 = max(abs(yd-ydpp)), pause
