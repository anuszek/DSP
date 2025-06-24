import numpy as np
import os
import scipy.io
from matplotlib import pyplot as plt

mat_file_path = os.path.join(os.path.dirname(__file__), "lab_03.mat")
mat = scipy.io.loadmat(mat_file_path)

x = mat[f'x_{420646%6 + 1}'].flatten()

M = 32  # prefix
N = 512  # ramka
K = 8  # liczba ramek
fs = 2.2e6  # próbkowanie

fig, axes = plt.subplots(2, 4, figsize=(16, 8))
axes = axes.flatten()

for i in range(K):
    start = i * (M + N) + M  # początek ramki po prefiksie
    ramka = x[start:start + N]  # pobranie ramki

    # FFT
    X = np.fft.fft(ramka)
    freq = np.fft.fftfreq(N, d=1/fs)  # skala częstotliwości

    # Plot on subplot
    axes[i].plot(freq[:N//2], np.abs(X[:N//2]))  # Tylko dodatnie częstotliwości
    axes[i].set_xlabel("Częstotliwość [Hz]")
    axes[i].set_ylabel("Amplituda")
    axes[i].set_title(f"FFT Ramki {i+1}")
    axes[i].grid()

    # Wykrywanie harmonicznych (progiem 90% wartości maksymalnej)
    threshold = 0.9 * np.max(np.abs(X))
    harmonic = freq[np.abs(X) > threshold]

    print(f"Ramka {i+1}: Wykryte harmoniczne:", harmonic)

plt.tight_layout()
plt.show()