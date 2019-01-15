# cat pluto.py 
#!/usr/bin/env python
#
# Copyright (C) 2018 Analog Devices, Inc.
# Author: Travis Collins <travis.collins@analog.com>
#
# Licensed under the GPL-2.

import sys
try:
    import iio
except:
    # By default the iio python bindings are not in path
    sys.path.append('/usr/lib/python2.7/site-packages/')
    import iio

import numpy as np
import math

# User configurable
TXLO = 1000000000
TXBW = 5000000
TXFS = 3000000
RXLO = TXLO
RXBW = TXBW
RXFS = TXFS

# Setup contexts
try:
    ctx = iio.Context('local:')
except:
    print("No device found")
    sys.exit(0)

ctrl = ctx.find_device("ad9361-phy")
txdac = ctx.find_device("cf-ad9361-dds-core-lpc")
rxadc = ctx.find_device("cf-ad9361-lpc")

# Configure transceiver settings
rxLO = ctrl.find_channel("altvoltage0", True)
rxLO.attrs["frequency"].value = str(int(RXLO))
txLO = ctrl.find_channel("altvoltage1", True)
txLO.attrs["frequency"].value = str(int(TXLO))

tx = ctrl.find_channel("voltage0",True)
tx.attrs["rf_bandwidth"].value = str(int(RXBW))
tx.attrs["sampling_frequency"].value = str(int(RXFS))
tx.attrs['hardwaregain'].value = '-30'

rx = ctrl.find_channel("voltage0")
rx.attrs["rf_bandwidth"].value = str(int(TXBW))
rx.attrs["sampling_frequency"].value = str(int(TXFS))
rx.attrs['gain_control_mode'].value = 'slow_attack'

# Enable all IQ channels
v0 = rxadc.find_channel("voltage0")
v1 = rxadc.find_channel("voltage1")
v0.enabled = True
v1.enabled = True

# Create buffer for RX data
rxbuf = iio.Buffer(rxadc, 2**15, False)

# Enable single tone DDS
dds0 = txdac.find_channel('altvoltage0',True)
dds2 = txdac.find_channel('altvoltage2',True)
dds0.attrs['raw'].value = str(1)
dds0.attrs['frequency'].value = str(100000)
dds0.attrs['scale'].value = str(0.9)
dds0.attrs['phase'].value = str(90000)
dds2.attrs['raw'].value = str(1)
dds2.attrs['frequency'].value = str(100000)
dds2.attrs['scale'].value = str(0.9)
dds2.attrs['phase'].value = str(0)

# Collect data
#reals = np.array([])
#imags = np.array([])

for i in range(10):
  N=131072
  rxbuf.refill()
  samples = rxbuf.read()
#  x = np.frombuffer(data,dtype=np.int16)
#  reals = np.real(data)
#  imags = np.imag(data)
#  reals = np.append(reals,x[::2])
#  imags = np.append(imags,x[1::2])
#  print("REAL:")
#  print(reals,imags)
  wav_samples = np.zeros((N, 2), dtype=np.float16)
  wav_samples[...,0] = np.real(samples)
  wav_samples[...,1] = np.imag(samples)
#  db = 10 * math.log10((reals**2)+(imags**2))
  print(wav_samples)
