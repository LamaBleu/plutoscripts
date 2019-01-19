local radio = require('radio')

if #arg < 1 then
    io.stderr:write("Usage: " .. arg[0] .. " <frequency>\n")
    os.exit(1)
end

local frequency = tonumber(arg[1])
local tune_offset = -100e3
local bandwidth = 5e3

-- Blocks
-- local source = radio.RtlSdrSource(frequency + tune_offset, 1102500)
local source = radio.SoapySDRSource("driver=plutosdr",frequency + tune_offset, 2400000, {rf_gain=73})
local tuner = radio.TunerBlock(tune_offset, 2*bandwidth, 50)
local am_demod = radio.ComplexMagnitudeBlock()
local dcr_filter = radio.SinglepoleHighpassFilterBlock(100)
local af_filter = radio.LowpassFilterBlock(128, bandwidth)
local af_gain = radio.AGCBlock('slow')
local sink = radio.WAVFileSink('/www/record.wav', 1,16)

-- Connections
local top = radio.CompositeBlock()
top:connect(source, tuner, am_demod, dcr_filter, af_filter, af_gain, sink)
top:run()

