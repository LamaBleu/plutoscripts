local radio = require('radio')

if #arg < 1 then
    io.stderr:write("Usage: " .. arg[0] .. " <frequency>\n")
    os.exit(1)
end

local frequency = tonumber(arg[1])
local tune_offset = -100e3
local deviation = 5e3
local bandwidth = 4e3

-- Blocks
-- local source = radio.RtlSdrSource(frequency + tune_offset, 1102500)
local source = radio.SoapySDRSource("driver=plutosdr",frequency + tune_offset, 1200000, {rf_gain = 72})
local tuner = radio.TunerBlock(tune_offset, 2*(deviation+bandwidth), 50)
local fm_demod = radio.FrequencyDiscriminatorBlock(deviation/bandwidth)
local af_filter = radio.LowpassFilterBlock(128, bandwidth)
local af_downsampler = radio.DownsamplerBlock(0.5)  -- Need 48000 as output rate
local sink = radio.WAVFileSink('/www/record.wav',1,16)

--  Connections
local top = radio.CompositeBlock()
top:connect(source, tuner, fm_demod, af_filter,  af_downsampler, sink)
io.stderr:write("Recording from " .. frequency / 1e6 .. " to  /www/record.wav \n")
top:run()

