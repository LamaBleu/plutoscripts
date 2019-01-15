
#!/bin/bash
losetup /dev/loop7 /opt/vfat.img -o 512
mount /dev/loop7 /gadget

