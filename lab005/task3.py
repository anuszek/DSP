import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

"""
Filtr eliptyczny jest najlepszym wyborem, ponieważ ma najmniejszy rząd (4) i spełnia wszystkie wymagania projektowe.

Jeśli priorytetem jest płaskość charakterystyki w paśmie przepustowym, można wybrać filtr Butterwortha (wyższy rząd = 7).
"""


# Parametry projektowe
fs = 256e3  # Częstotliwość próbkowania [Hz]
fp = 64e3   # Częstotliwość graniczna pasma przepustowego [Hz]
fs_stop = 128e3  # Częstotliwość graniczna pasma zaporowego [Hz]
Ap = 3      # Maksymalne tłumienie w paśmie przepustowym [dB]
As = 40     # Minimalne tłumienie w paśmie zaporowym [dB]

# Projektowanie filtrów
# Butterworth
N_butter, Wn_butter = signal.buttord(fp, fs_stop, Ap, As, analog=True)
b_butter, a_butter = signal.butter(N_butter, Wn_butter, btype='lowpass', analog=True)

# Czebyszew I
N_cheby1, Wn_cheby1 = signal.cheb1ord(fp, fs_stop, Ap, As, analog=True)
b_cheby1, a_cheby1 = signal.cheby1(N_cheby1, Ap, Wn_cheby1, btype='lowpass', analog=True)

# Czebyszew II
N_cheby2, Wn_cheby2 = signal.cheb2ord(fp, fs_stop, Ap, As, analog=True)
b_cheby2, a_cheby2 = signal.cheby2(N_cheby2, As, Wn_cheby2, btype='lowpass', analog=True)

# Eliptyczny
N_ellip, Wn_ellip = signal.ellipord(fp, fs_stop, Ap, As, analog=True)
b_ellip, a_ellip = signal.ellip(N_ellip, Ap, As, Wn_ellip, btype='lowpass', analog=True)

# Charakterystyka częstotliwościowa
f = np.logspace(3, 6, 1000)  # Zakres częstotliwości [Hz]
w = 2 * np.pi * f  # Pulsacja [rad/s]

# Obliczenie odpowiedzi częstotliwościowej
_, H_butter = signal.freqs(b_butter, a_butter, w)
_, H_cheby1 = signal.freqs(b_cheby1, a_cheby1, w)
_, H_cheby2 = signal.freqs(b_cheby2, a_cheby2, w)
_, H_ellip = signal.freqs(b_ellip, a_ellip, w)

# Wykres charakterystyki amplitudowo-częstotliwościowej (decybele)
plt.figure(figsize=(12, 6))
plt.semilogx(f, 20 * np.log10(np.abs(H_butter)), label='Butterworth (N={})'.format(N_butter))
plt.semilogx(f, 20 * np.log10(np.abs(H_cheby1)), label='Czebyszew I (N={})'.format(N_cheby1))
plt.semilogx(f, 20 * np.log10(np.abs(H_cheby2)), label='Czebyszew II (N={})'.format(N_cheby2))
plt.semilogx(f, 20 * np.log10(np.abs(H_ellip)), label='Eliptyczny (N={})'.format(N_ellip))
plt.axvline(fp, color='k', linestyle='--', label='f_p = 64 kHz')
plt.axvline(fs_stop, color='r', linestyle='--', label='f_s = 128 kHz')
plt.axhline(-3, color='g', linestyle='--', label='-3 dB')
plt.axhline(-40, color='m', linestyle='--', label='-40 dB')
plt.xlabel('Częstotliwość [Hz]')
plt.ylabel('Tłumienie [dB]')
plt.title('Charakterystyka amplitudowo-częstotliwościowa filtrów')
plt.grid(which='both', linestyle='--', linewidth=0.5)
plt.legend()
plt.xlim(1e3, 1e6)
plt.ylim(-80, 5)
plt.show()

# Wykres biegunów i zer
def plot_poles_zeros(b, a, title):
    zeros = np.roots(b)
    poles = np.roots(a)
    plt.figure(figsize=(8, 6))
    plt.scatter(np.real(zeros), np.imag(zeros), marker='o', color='b', label='Zera')
    plt.scatter(np.real(poles), np.imag(poles), marker='x', color='r', label='Bieguny')
    plt.axhline(0, color='k', linestyle='--', linewidth=0.5)
    plt.axvline(0, color='k', linestyle='--', linewidth=0.5)
    plt.xlabel('Część rzeczywista')
    plt.ylabel('Część urojona')
    plt.title('Rozkład biegunów i zer: ' + title)
    plt.grid()
    plt.legend()
    plt.show()

plot_poles_zeros(b_butter, a_butter, 'Butterworth')
plot_poles_zeros(b_cheby1, a_cheby1, 'Czebyszew I')
plot_poles_zeros(b_cheby2, a_cheby2, 'Czebyszew II')
plot_poles_zeros(b_ellip, a_ellip, 'Eliptyczny')