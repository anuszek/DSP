import numpy as np
import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('TkAgg')

def singen(amplitude, duration, frequency, sampling_rate, phase):
    t = np.arange(0, duration, 1/sampling_rate)
    signal = amplitude * np.sin(2 * np.pi * frequency * t + phase)
    return signal, t

amplA = 230
freqA = 50
timeA = 0.3
phase = 0

# signal sampled fs3 = 200 Hz
fs3 = 200
sin200, time200 = singen(amplA, timeA, freqA, fs3, phase)

# new time instances for fs = 10 kHz
fs = 10000
time_high_res = np.arange(0, timeA, 1/fs)

# signal reconstruction
t_size = len(time_high_res)  # number of samples in new time grid
reconstructed_signal = np.zeros(t_size)  
Ts = 1/fs3  # sampling period

for idx in range(t_size):
    t_rec = time_high_res[idx]
    reconstructed_signal[idx] = np.sum(sin200 * np.sinc((t_rec - time200) / Ts))

# original pseudo-analog signal
sin_analog, _ = singen(amplA, timeA, freqA, fs, phase)

# reconstruction error
error = sin_analog - reconstructed_signal

plt.figure()
plt.plot(time_high_res, reconstructed_signal, label='Reconstructed Signal')
plt.plot(time_high_res, sin_analog, label='Original Signal', linestyle='dashed')
plt.legend()
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.title('Signal Reconstruction')
plt.show()

plt.figure()
plt.plot(time_high_res, sin_analog, 'b', label='Original signal (pseudo-analog)')
plt.plot(time_high_res, reconstructed_signal, 'r', linestyle='dashed', label='Reconstructed signal')
plt.xlabel('Time [s]')
plt.ylabel('Amplitude')
plt.legend()
plt.title('Signal comparison')
plt.grid()
plt.show()

plt.figure()
plt.plot(time_high_res, error, 'k', label='Reconstruction error')
plt.xlabel('Time [s]')
plt.ylabel('Error')
plt.legend()
plt.title('Reconstruction error')
plt.grid()
plt.show()