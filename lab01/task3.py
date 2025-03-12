import numpy as np
from scipy import io
import os
import matplotlib.pyplot as plt


mat_data = io.loadmat(os.path.join(os.path.dirname(__file__), 'adsl_x.mat'))
input_signal = mat_data['x'].flatten()

# signal parameters
K = 4  # repetition factor
M = 32  # prefix length
N = 512  # block length

prefix_starts = np.zeros(K)
correlation_range = np.arange(0, 2080, 1)

for k in range(K):
    idx_start = (k + 1) * N
    prefix = input_signal[idx_start-M-1:idx_start-1]

    # cross correlation between prefix and signal
    r = np.correlate(input_signal, prefix, mode='full')

    # find the index of the prefix start in the signal
    prefix_starts[k] = np.argmax(r)

    # plt.plot(correlation_range, r)
    # plt.show()

print(np.abs(prefix_starts - M + 1))


def xcorr(prefix, signal):
    len_prefix = len(prefix)
    len_signal = len(signal)

    correlation = np.zeros(len_prefix + len_signal - 1) 

    signal = signal[::-1]

    for i in range(len_prefix + len_signal - 1):
        sum = 0
        for j in range(len_prefix):
            if 0 <= i - j < len_signal:
                sum += prefix[j] * signal[i - j]
        correlation[i] = sum

    return correlation[::-1]

# usage of mine xcorr function
for k in range(K):
    idx_start = (k + 1) * N
    prefix = input_signal[idx_start-M-1:idx_start-1]

    correlation = xcorr(prefix, input_signal)

    prefix_starts[k] = np.argmax(correlation)


print(np.abs(prefix_starts - M + 1))