import numpy as np
import matplotlib.pyplot as plt

amplitude = 10
fs = 100
duration = 1

frequencies_to_compare = [(5, 105, 205), (95, 195, 295), (95, 105)]

def generate_sin_wave(amp, freq, sampling_rate, duration):
  t = np.linspace(0, duration, int(sampling_rate * duration))
  sine = amp * np.sin(2 * np.pi * freq * t)
  return t, sine

def generate_cos_wave(amp, freq, sampling_rate, duration):
  t = np.linspace(0, duration, int(sampling_rate * duration))
  cosine = amp * np.cos(2 * np.pi * freq * t)
  return t, cosine


for freq in range(0, 301, 5):
  t, sine = generate_sin_wave(amplitude, freq, fs, duration)

plt.figure()
plt.suptitle('Comparison of sine waves')
for i, freqs in enumerate(frequencies_to_compare):
  plt.subplot(3, 1, i + 1)
  for freq in freqs:
    t, sine = generate_sin_wave(amplitude, freq, fs, duration)
    plt.plot(t, sine, label=f'{freq} Hz')
  plt.legend()
  plt.grid()
plt.show()


for freq in range(0, 301, 5):
  t, cosine = generate_cos_wave(amplitude, freq, fs, duration)

plt.figure()
plt.suptitle('Comparison of cosine waves')
for i, freqs in enumerate(frequencies_to_compare):
  plt.subplot(3, 1, i + 1)
  for freq in freqs:
    t, cosine = generate_cos_wave(amplitude, freq, fs, duration)
    plt.plot(t, cosine, label=f'{freq} Hz')
  plt.legend()
  plt.grid()

plt.show()