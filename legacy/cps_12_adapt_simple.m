% cps_12_adapt_simple.m - proste demo filtracji adaptacyjnej LMS
clear all; close all;

% Parametry sygnalow
fpr = 1000;                     % czestotliwosc probkowania
Nx = fpr;                       % liczba probek, 1 sekunda
dt = 1/fpr; t = 0:dt:(Nx-1)*dt; % czas
f = 0:fpr/1000:fpr/2;           % czestotliwosc

if(1) % Scenariusz #1 - adaptacyjne usuwanie interferencji
   M = 50;                                   % liczba wag filtra
   mi = 0.1;                                 % szybkosc adaptacji ( 0<mi<1)
   s = sin(2*pi*10*t).*exp(-25*(t-0.5).^2);  % sygnal: sinus*gaussoida, EKG lub mowa
   z = sin(2*pi*200*t);                      % zaklocenie: harmoniczne, "warkot"
   d = s + 0.5*z;                            % sygnal + przeskalowane zaklocenie
   x = 0.2*[zeros(1,5) z(1:end-5)];          % opozniona i stlumiona kopia zaklocenia
else  % Scenariusz #2 - adaptacyjne odszumianie/uzdatnianie sygnalu 
   M = 10;                                   % liczba wag filtra
   mi = 0.0025;                              % szybkosc adaptacji ( 0<mi<1)
   s = sin(2*pi*200*t);                      % sygnał: sinus, EKG lub mowa
   z = 0.3*randn(1,Nx);                      % zaklocenie szumowe
   d = s + z;                                % zaklocony sygnal
   x = [ 0, d(1:end-1)];                     % opozniona kopia zakloconego sygnalu
end   
        figure;
        subplot(211); plot(t,d,'r'); grid; title('WE : d(n)');
        subplot(212); plot(t,x,'b'); grid; title('WE : x(n)'); xlabel('czas (s)'); pause

% Filtracja adaptacyjna
bx = zeros(M,1);         % inicjalizacja bufora na probki sygnalu wejsciowego x(n)
h  = zeros(M,1);         % inicjalizacja wag filtra
y  = zeros(1,Nx);        % wyjscie puste, jeszcze nic nie zawiera 
e  = zeros(1,Nx);        % wyjscie puste, jeszcze nic nie zawiera
for n = 1 : length(x)              % Petla glowna
  % n                              % indeks petli
    bx = [ x(n); bx(1:M-1) ];      % wstawienie nowej probki x(n) do bufora
    y(n) = h' * bx;                % filtracja x(n), czyli estymacja d(n)
    e(n) = d(n) - y(n);            % blad estymacji
    h = h + ( 2*mi * e(n) * bx );  % LMS  - adaptacja wag filtra
    
        if(0) % Obserwacja wag filtra oraz jego odpowiedzi czestotliwosciowej
            subplot(211); stem(h); xlabel('n'); title('h(n)'); grid;
            subplot(212); plot(f,abs(freqz(h,1,f,fpr))); xlabel('f (Hz)');
            title('|H(f)|'); grid; pause(0.1)
        end   
end
  
% Rysunki - sygnaly wyjsciowe z filtra adaptacyjnego

        figure;
        subplot(211); plot(t,e,'r'); grid; title('WY : sygnal e(n) = d(n)-y(n)');
        subplot(212); plot(t,y,'b'); grid; title('WY : sygnal y(n) = destim');
        xlabel('czas [s]'); pause

        figure; subplot(111); plot(t,s,'g',t,e,'r',t,y,'b');
        grid; xlabel('czas [s]'); title('Sygnały WE i WY');
        legend('s(n) - oryginal','e(n) = d(n)-y(n)','y(n) = filtr[x(n)]'); pause
