local radio = require('radio')
N = 98000000
os.execute("echo manual > /sys/bus/iio/devices/iio:device1/in_voltage0_gain_control_mode")
local src = radio.SoapySDRSource("driver=plutosdr", N, 10000000, {{gain = 70},{bandwidth=10e6}})
local throttle = radio.ThrottleBlock()
local plot = radio.GnuplotSpectrumSink(4096*4, 'Frequency = 98000000 ', {yrange = {-110, -40}, {overlap_fraction = 0.1}})
local top = radio.CompositeBlock()
top:connect(src, plot)
top:start()
if top:status().running then
    os.execute("sleep 4")
end
top:stop()

