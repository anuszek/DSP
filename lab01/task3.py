import numpy as np
from scipy import io
import os
import matplotlib.pyplot as plt


def xcorr(prefix, signal):
    len_prefix = len(prefix)
    len_signal = len(signal)

    correlation = np.zeros(len_prefix + len_signal - 1) 

    signal = signal[::1]

    for i in range(len_prefix + len_signal - 1):
        sum = 0
        for j in range(len_prefix):
            if 0 <= i - j < len_signal:
                sum += prefix[j] * signal[i - j]
        correlation[i] = sum

    return correlation[::1]

mat_data = io.loadmat(os.path.join(os.path.dirname(__file__), 'adsl_x.mat'))
input_signal = mat_data['x'].flatten()

# signal parameters
K = 4  # repetition factor
M = 32  # prefix length
N = 512  # block length

best_prefix = list()
best_score = list()
prefix_positions = list()

for i in range(len(input_signal)):
    prefix = input_signal[i:i+M]
    correlation = np.correlate(prefix, input_signal, mode='full')
    # correlation = xcorr(prefix, input_signal)

    if len(np.where(correlation == max(correlation))[0]) >= 2:
        best_prefix.append(prefix)
        best_score.append(correlation)
        prefix_positions.append(i)

for i in range(len(best_score)):
    plt.axvline(prefix_positions[i], color='red')
    if i % 2 == 1:
        plt.plot(best_score[i])
        plt.show()

print(prefix_positions)

