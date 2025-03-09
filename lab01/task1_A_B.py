import numpy as np
import matplotlib.pyplot as plt

amplitude = 230
frequency = 50

# sampling rates
f_s_A = [10_000, 500, 200]
f_s_B1 = [10_000, 51, 50, 49]
f_s_B2 = [10_000, 26, 25, 24]

def generate_wave(amp, freq, sampling_rate, duration):
  t = np.linspace(0, duration, int(sampling_rate * duration))
  sine = amp * np.sin(2 * np.pi * freq * t)
  return t, sine

waves_0_1s = [generate_wave(amplitude, frequency, f, duration=0.1) for f in f_s_A]
t = [w[0] for w in waves_0_1s]
sines = [w[1] for w in waves_0_1s]

plt.figure()
plt.plot(t[0], sines[0], 'b-', label='10000 Hz')
plt.plot(t[1], sines[1], 'r-o', label='500 Hz')
plt.plot(t[2], sines[2], 'k-x', label='200 Hz')
plt.legend()
plt.grid()
plt.show()

waves_1s = [generate_wave(amplitude, frequency, f, duration=1) for f in f_s_B1]
t = [w[0] for w in waves_1s]
sines = [w[1] for w in waves_1s]

plt.figure()
plt.plot(t[0], sines[0], 'b-', label='10000 Hz')
plt.plot(t[1], sines[1], 'g-o', label='51 Hz')
plt.plot(t[2], sines[2], 'r-o', label='50 Hz')
plt.plot(t[3], sines[3], 'k-o', label='49 Hz')
plt.legend()
plt.grid()
plt.show()

waves_1s = [generate_wave(amplitude, frequency, f, duration=1) for f in f_s_B2]
t = [w[0] for w in waves_1s]
sines = [w[1] for w in waves_1s]

plt.figure()
plt.plot(t[0], sines[0], 'b-', label='10000 Hz')
plt.plot(t[1], sines[1], 'g-o', label='26 Hz')
plt.plot(t[2], sines[2], 'r-o', label='25 Hz')
plt.plot(t[3], sines[3], 'k-o', label='24 Hz')
plt.legend()
plt.grid()
plt.show()

fs = 100
duration = 1

for freq in range(0, 301, 5):
  t, sine = generate_wave(amplitude, freq, fs, duration)

# Compare specific sine waves
frequencies_to_compare = [(5, 105, 205), (95, 195, 295), (95, 105)]
for freqs in frequencies_to_compare:
  plt.figure()
  for freq in freqs:
    t, sine = generate_wave(amplitude, freq, fs, duration)
    plt.plot(t, sine, label=f'{freq} Hz')
  plt.legend()
  plt.grid()
  plt.show()

# Generate and display cosine waves
def generate_cos_wave(amp, freq, sampling_rate, duration):
  t = np.linspace(0, duration, int(sampling_rate * duration))
  cosine = amp * np.cos(2 * np.pi * freq * t)
  return t, cosine

for freq in range(0, 301, 5):
  t, cosine = generate_cos_wave(amplitude, freq, fs, duration)

# Compare specific cosine waves
for freqs in frequencies_to_compare:
  plt.figure()
  for freq in freqs:
    t, cosine = generate_cos_wave(amplitude, freq, fs, duration)
    plt.plot(t, cosine, label=f'{freq} Hz')
  plt.legend()
  plt.grid()
  plt.show()