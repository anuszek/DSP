% cps_01_sinus.m
  clear all; close all;

  fpr=1000; Nx=1000;              % parametry: czestotliwosc probkowania, liczba probek             
  dt = 1/fpr;                     % okres probkowania 
  n = 0 : Nx-1;                   % numery probek        
  t = dt*n;                       % chwile probkowania
  A1=0.5; f1=10; p1=pi/4;         % sinusoida: amplituda, czestotliwosc, faza
  x1 = A1*sin(2*pi*f1    *t+p1);  % pierwszy skladnik sygnalu
% x1 = A1*sin(2*pi*f1/fpr*n+p1);  % pierwszy składnik inaczej zapisany
% x2 = ?;                         % drugi skladnik
% x3 = ?;                         % trzeci skladnik
  x = x1;                         % wybor skladowych: x = x1, x1 + 0.123*x2 + 0.456*x3   
  plot(t,x,'bo-'); grid; title('Sygnal x(t)'); xlabel('Czas [s]'); ylabel('Amplituda');