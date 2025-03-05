% cps_13_aac_kwant.m - kontynuacja cps_13_aac.m - kwantyzacja

% Decyzja? Jaka liczba bitów w kazdym podpasmie 
b = [5*ones(1,M/4), 4*ones(1,M/4), 3*ones(1,M/4), 2*ones(1,M/4)]; sc=2.^(b-1)+0.49;
%b = 5*ones(1,M); sc = 2.^(b-1)+0.49;

% Kwantyzacja w podpasmach
sbmax = max( abs(sb) );                         % znajdz maksima
sb = sbmax .* fix( sc .* (sb./sbmax) ) ./ sc;   % skwantuj

% Synteza sygnalu ze skwantowanych probek podpasmowych
y = zeros(Nx,1);                                % sygnal wyjsciowy
for k=1:Nmany                                   % PETLA SYNTEZY SYGNALU
    n = 1+(k-1)*M  : N + (k-1)*M;               % numery probek od do
    BX = sb(k,1:M)';                            % odtworzenie podpasm
    by = D*BX;                                  % IMDCT
    y( n ) = y( n ) + by .* win;                % rekonstrukcja sygnalu z oknem
end                                             % KONIEC PETLI
xqs = y;                                        % zmien nazwe

% Kwantyzacja sygnalu oryginalnego: 2^b+1 poziomy kwantyzacji
b=5; sc=2^(b-1)+0.49; xmax=max(abs(x)); xq = xmax * fix( sc*x/xmax ) / sc;

% Porownanie
m=M+1:Nx-M;
figure; plot(m,x(m),'ro',m,xq(m),'bx',m,xqs(m),'g*'); title('x(R), xq(B), xqs(G)'); pause
SNR1 = 10*log10( sum(x(m).^2) / sum( (x(m)-xq(m)).^2 )  ),
SNR2 = 10*log10( sum(x(m).^2) / sum( (x(m)-xqs(m)).^2 ) ),
max_abs_error_xq  = max(abs(x(m)-xq(m))),
max_abs_error_xqs = max(abs(x(m)-xqs(m))),
[X  ,f] = periodogram(  x,[],512,fpr,'power'); X  =10*log10(X);
[Xq ,f] = periodogram( xq,[],512,fpr,'power'); Xq =10*log10(Xq);
[Xqs,f] = periodogram(xqs,[],512,fpr,'power'); Xqs=10*log10(Xqs);
figure; plot(f,X,'r-',f,Xq,'b-',f,Xqs,'g-'); xlabel('f (Hz)'); title('Power (dB)');
legend('x(n)','xq(n)','xqs(n)','Location','SouthWest'); grid; pause
