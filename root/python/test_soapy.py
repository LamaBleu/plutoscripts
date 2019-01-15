import SoapySDR
from SoapySDR import * #SOAPY_SDR_ constants
import numpy #use numpy for buffers
import math
import numpy, random
import sys



#enumerate devices
results = SoapySDR.Device.enumerate()
for result in results: print(result)

#create device instance
#args can be user defined or from the enumeration result
args = dict(driver="plutosdr")
sdr = SoapySDR.Device(args)

#query device info
print(sdr.listAntennas(SOAPY_SDR_RX, 0))
print(sdr.listGains(SOAPY_SDR_RX, 0))
freqs = sdr.getFrequencyRange(SOAPY_SDR_RX, 0)
for freqRange in freqs: print(freqRange)

#apply settings
sdr.setSampleRate(SOAPY_SDR_RX, 0, 4e6)
sdr.setFrequency(SOAPY_SDR_RX, 0, 93e6)

#setup a stream (complex floats)
rxStream = sdr.setupStream(SOAPY_SDR_RX, SOAPY_SDR_CF32)
sdr.activateStream(rxStream) #start streaming

#create a re-usable buffer for rx samples
buff = numpy.array([0]*1024, numpy.complex64)

sr = sdr.readStream(rxStream, [buff], len(buff)/4)

#receive some samples
for i in range(1):
    sr = sdr.readStream(rxStream, [buff], len(buff))
    print(sr.ret) #num samples or error code
    print(sr.flags) #flags set by receive operation
    print(sr.timeNs) #timestamp for receive buffer
  
    if len(buff) != sr.ret:
           raise Exception('receive fail - captured samples %d out of %d'%(len(sr.ret), len(buff)))
    print(' OK - captured samples %d out of %d'%(sr.ret, len(buff)))
    print " I/Q:"
    print buff[:16]
    data = buff
#    savebuff = buff
#    savebuff = numpy.array(buff, numpy.complex64)
#    numpy.save('samples.txt', buff)




#shutdown the stream
sdr.deactivateStream(rxStream) #stop streaming
sdr.closeStream(rxStream)

#ivalue = numpy.real
ivalue = numpy.real(buff[0::])
qvalue = numpy.imag(buff[0::])

print('I :')
print(ivalue[:15])
print ('J : ')
print(qvalue[:15])

# Save

f= open("samples.bin","w+")
f.write(buff)


#print(ivalue[0]),(numpy.power(ivalue[0],2))
#print(qvalue[0]),(numpy.power(qvalue[0],2))
#dbpower = numpy.power(reals+imags,0.5)

#print(dbpower)



# Compute : dbpower1 = 10 * math.log10((ivalue**2)+(qvalue**2))

reals = (numpy.power(ivalue[0],2))
imags = (numpy.power(qvalue[0],2))
dbpower1 = 10 * math.log10(reals+imags)

print(10*dbpower1)



reals = numpy.append(reals,buff[::2])
imags = numpy.append(imags,buff[1::2])


#numpy.power((numpy.power(reals,2)+numpy.power(imags,2)),0.5) = diib
#print(diib)



frame_array = numpy.fromstring(buff, dtype=numpy.float16)
print(frame_array.size)

