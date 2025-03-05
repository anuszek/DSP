function [y, e, h] = adaptTZ(d,x,M,mi,gamma,lambda,delta,ialg)
% M-dlugosc filtra, LMS: mi, NLMS: mi, gamma, RLS: lambda, delta

% Inicjalizacja
h  = zeros(M,1);       % wagi filtra
bx = zeros(M,1);       % bufor wejsciowy na probki x(n)
Rinv = delta*eye(M,M); % odwrotnosc macierzy autokorelacji Rxx^{-1} sygnalu x(n)

% Głowna petla adaptacyjna z trzema metodami: LMS, NLMS i RLS
for n = 1 : length(x)           % glowna petla filtracji adaptacynej
    bx = [ x(n); bx(1:M-1) ];   % pobranie nowej probki sygnalu x(n) do bufora
    y(n) = h' * bx;             % filtracja sygnalu x(n): y(n) = sum( h .* bx)
    e(n) = d(n) - y(n);         % obliczenie bledu niedopasowania e(n)
    if(ialg==1)      % 1) filtr LMS
        h = h + mi * e(n) * bx;                 % korekta wag filtra
    elseif(ialg==2)  % 2) filtr NLMS
        energy = bx' * bx;                      % energia sygnalu x(n) w buforze
        h = h + mi/(gamma+energy) * e(n) * bx;  % korekta wag filtra
    else             % 3) filtr RLS
        Rinv = (Rinv - Rinv*bx*bx'*Rinv/(lambda+bx'*Rinv*bx))/lambda; % korekta Rinv
        h = h + Rinv * bx * e(n);                                     % korekta h
    end
end
