cd /root/luaradio
sed "s/98000000/$1/g" /root/luaradio/lplot20.lua > /tmp/plot.lua
luaradio /tmp/plot.lua



