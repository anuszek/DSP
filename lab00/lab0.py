import numpy as np
import matplotlib.pyplot as plt
from scipy.io.wavfile import write
from scipy.signal import spectrogram
time: int = 10  # s
max_freq: int = 44100
start_ferq: int = 1000
d_ferq: int = 5000  # Hz/s

t = np.linspace(0, time, time * max_freq)
freq = start_ferq + d_ferq * t
sine = np.sin(2 * np.pi * freq * t)

sine_normalized = sine / np.max(np.abs(sine))
sine_pcm = np.int16(sine_normalized * 32767)
write('sine_wave.wav', max_freq, sine_pcm)


plt.plot(t, sine)
plt.xlim(0, 0.1)
plt.grid()
plt.show()

f, t, Sxx = spectrogram(sine, max_freq)
plt.pcolormesh(t, f, Sxx)
plt.show()

