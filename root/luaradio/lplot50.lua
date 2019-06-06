os.execute("echo manual > /sys/bus/iio/devices/iio:device1/in_voltage0_gain_control_mode")
local radio = require('radio')
N = arg[1]
os.execute("iio_attr -q -a -c -i ad9361-phy voltage0 rf_bandwidth 54000000")
local src = radio.SoapySDRSource("driver=plutosdr", arg[1]*1000, 50000000, {bandwidth=50e6})
local throttle = radio.ThrottleBlock()
local plot = radio.GnuplotSpectrumSink(4096*4, "Freq. : " .. arg[1] .. " KHz" , {overlap_fraction = 0.1})
local top = radio.CompositeBlock()
top:connect(src, plot)
top:start()
if top:status().running then
    os.execute("sleep 8")
end
top:stop()

