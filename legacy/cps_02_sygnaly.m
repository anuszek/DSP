% cps_02_sygnaly.m
clear all; close all;

fs=100; Nx=1000;                % czestotliwosc probkowania, liczba probek
dt = 1/fs;                      % okres probkowania 
t = dt*(0:Nx-1);                % chwile pobierania probek
x1=sin(2*pi*10*t);              % sinus 10 Hz
x2=sin(2*pi*1*t);               % sinus 1 Hz
x3=exp(-5*t);                   % eksponenta opadajaca w czasie 
x4=exp(-25*(t-0.5).^2);         % gaussoida
x5=sin(2*pi*(0*t+0.5*2*t.^2)); % liniowy przyrost czest. (LFM): od 0 Hz, +20Hz/s
x6=sin(2*pi*(10*t-(9/(2*pi*1)*cos(2*pi*1*t)))); % sinus. FM: 9Hz wokol 10Hz 1x na sec 
x7=sin(2*pi*(10*t+9*cumsum(x2)*dt));            % to samo co x6; dlaczego?
x = x1;                         % wybor: x1,x2,...,x7, 0.23*x1 + x2, x1.*x3, ... 
plot(t,x,'o-'); grid; title('Sygnal x(t)'); xlabel('czas [s]'); ylabel('Amplituda'); 
