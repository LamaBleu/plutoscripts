-- Example usage: luaradio rtlsdr_noaa_apt.lua 137.62e6 /www/record.wav 
-- Replay from computer : play -r 11050 -t raw -e s -b 16 -c 1 -V1 http://192.168.2.1/record.wav 


local radio = require('radio')
 outputfile
if #arg < 2 then
    io.stderr:write("Usage: " .. arg[0] .. " <RF centre frequency> <Output filename>\n")
    os.exit(1)
end
 
local frequency = tonumber(arg[1])
-- local output_file = tostring(arg[2])
local tune_offset = -250e3
local if_bandwidth = 45e3
local af_bandwidth = 5e3

io.stderr:write("Frequency " .. frequency  ..  "\n")
 
-- Blocks
local source = radio.SoapySDRSource("driver=plutosdr",frequency + tune_offset, 1102500, {rf_gain = 72})
local tuner = radio.TunerBlock(tune_offset, if_bandwidth, 10)
local fm_demod = radio.FrequencyDiscriminatorBlock(0.85)
local af_filter = radio.LowpassFilterBlock(128, af_bandwidth)
local af_downsampler = radio.DownsamplerBlock(10)  -- Need 11025 as output rate
local wav_sink = radio.WAVFileSink(output_file,1,16)  -- Single channel, 16 bit samples

 
-- Connections
local top = radio.CompositeBlock()
top:connect(source, tuner, fm_demod, af_filter, af_downsampler, wav_sink)

 
-- Let's go
io.stderr:write("Recording from " .. frequency / 1e6 .. " to " .. output_file .. "\n")
top:run()


