% cps_11_hilb_amfm.m - demodulacja AM i FM z uzyciem filtru Hilberta
clear all; close all;

fpr=2000; dt=1/fpr; Nx=fpr; t=dt*(0:Nx-1); 
A=10; kA=0.5; fA=2;   xA = A*(1 + kA*sin(2*pi*fA*t));
kF=250; fF=1;         xF = kF*sin(2*pi*fF*t);
fc=500;               x = xA .* sin(2*pi*(fc*t + cumsum(xF)*dt));
xa = hilbert( x );
xAest = abs( xa );
ang = unwrap(angle( xa ));
xFest = (1/(2*pi)) * (ang(3:end)-ang(1:end-2)) / (2*dt);
figure; plot(t,xA,'r-',t,xAest,'b-'); title('AM'); grid;
figure; plot(t,xF,'r-',t(2:Nx-1),xFest-fc,'b-'); title('FM'); grid;
