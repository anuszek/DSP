import numpy as np
from matplotlib import pyplot as plt
import matplotlib
import sounddevice as sd


def playsound(signal, fs):
    sd.play(signal, fs)


matplotlib.use('TkAgg')

Imie = "Maurycy"

Imie_bin = ''.join(format(ord(i), '08b') for i in Imie)

print(f'Imie w formie binarnej: {Imie_bin}')

fs = 16 * pow(10, 3)

T = 0.1

freq = 500

signal = np.array([])

t_bit = np.arange(0, T, 1 / fs)

carrier_0 = np.sin(2 * np.pi * freq * t_bit)
carrier_1 = -np.sin(2 * np.pi * freq * t_bit)

soundFreq = [8000, 16000, 24000, 32000, 48000]

for bit in Imie_bin:
    if bit == '0':
        signal = np.append(signal, carrier_0)
    else:
        signal = np.append(signal, carrier_1)

print(len(signal))
t_plot = np.arange(0, min(0.5, len(Imie) * T), 1 / fs)
plt.plot(t_plot, signal[:len(t_plot)])
plt.show()

# for s in soundFreq:
#     sd.play(signal, s)
#     sd.wait()

samplesPerBit = int(T * fs)
numBits = len(Imie_bin)

decodedBits = ''

for i in range(numBits):
    signalSegment = signal[i*samplesPerBit:(i+1)*samplesPerBit]
    dot = np.sum(signalSegment * carrier_0)
    if dot > 0:
        decodedBits += '0'
    else:
        decodedBits += '1'

text = ''

for i in range(0, len(decodedBits), 8):
    byte = decodedBits[i:i+8]
    if len(byte) == 8:
        text += chr(int(byte, 2))

print(f'Imię po dekodowaniu: {text}')