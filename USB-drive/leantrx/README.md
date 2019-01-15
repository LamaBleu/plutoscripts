LeanTRX: a web interface for LeanSDR on embedded SDR platforms.

# Documentation

See http://www.pabr.org/radio/leantrx/

# Development

https://www.github.com/pabr/leantrx (web interface)
https://www.github.com/pabr/leansdr (SDR functions)

# LeanTRX license

Copyright (c) 2018 <pabr@pabr.org>

> This program is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.
> 
> This program is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
> 
> You should have received a copy of the GNU General Public License
> along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Third-party licenses

If you have received a pre-compiled version of this software, the
following notices are applicable on some platforms:

- leantrx/bsp/plutosdr/*/{cdc_ether.ko,rndis_host.ko} are compiled
  from http://github.com/analogdevicesinc/linux after enabling
  CONFIG_USB_NET_CDCETHER=m and CONFIG_USB_NET_RNDIS_HOST=m.
  cdc_ether.c and rndis_host.c are GPL2+.

- Most binaries under leantrx/bin/ are compiled from LeanSDR (GPL3+).

- leantrx/bin/*/leanmlmrx may be statically linked against
  libfftw3f (GPL2+).

- leantrx/bin/*/leaniio{rx,tx} may be statically linked against
  http://github.com/analogdevicesinc/libiio (GPL2.1+).
