Some scripts I'm using for the Pluto.
Should work on every Pluto if corresponding applications are installed.
Have a look to USB-drive/README.txt for details.
Adapt to your needs and correct my mistakes.

Full doc, see USB-drive/README.txt on : https://github.com/LamaBleu/plutoscripts/tree/master/USB-drive

Firmware including the scripts and apps, download link : 
https://mega.nz/#F!C8hgFASK!C9DfCjU7ou46mG-LNWQTrQ

Take care to the revB submodel before flashing, see below.


==============================================


Twitter @5GReady user first reported an issue on flashing failing at around 22-23 MB (firmware filesize is 32MB)

Few investigations showed a batch of 1000 Plutos are not able to support flashing firmware file over 22MB size.
It's always possible to downgrade back to official 0.29 version using same DFU command, no worries.




***** How to find  if your pluto device is coming from the first batch (0) or not (1) :

Type following command :    iio_info | grep variant
 result :    hw_model_variant : 1       --->    will support firmware size up to 32MB
                                0       --->    flash will fail for size over 23MB.  


Download a "light-version" instead, compatible with all revB boards.
Workaround exists, be prudent : https://ez.analog.com/university-program/f/q-a/105941/adalm-pluto---firmware-dfu-flashing-fails-at-22-23mb/313815

