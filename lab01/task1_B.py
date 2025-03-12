import numpy as np
import matplotlib.pyplot as plt

amplitude = 1
frequency = 50

# sampling rates
f_s_B1 = [10_000, 51, 50, 49]
f_s_B2 = [10_000, 26, 25, 24]


def generate_wave(amp, freq, sampling_rate, duration):
  t = np.linspace(0, duration, int(sampling_rate * duration))
  sine = amp * np.sin(2 * np.pi * freq * t)
  return t, sine


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

