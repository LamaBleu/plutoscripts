local radio = require('radio')


    io.stderr:write("Usage: " .. arg[0] .. " <bandwidth> \n")


-- assert(arg[4] == "usb" or arg[4] == "lsb", "Sideband should be 'lsb' or 'usb'.")

local bandwidth = tonumber(arg[1])

-- Blocks
local source = radio.WAVFileSource('/tmp/send.png.wav', 1)
local af_filter = radio.LowpassFilterBlock(128, bandwidth)
local hilbert = radio.HilbertTransformBlock(129)
local sb_filter = radio.ComplexBandpassFilterBlock(129, {0, bandwidth})
local sink = radio.IQFileSink('/tmp/send.png.iq', 'f32le')
-- Connections
local top = radio.CompositeBlock()
      top:connect(source, af_filter, hilbert, sb_filter, sink)

top:run()

