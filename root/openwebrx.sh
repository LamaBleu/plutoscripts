cd /openwebrx

if [ "$#" -eq  "0" ]
   then
     echo ""
 else
   echo "New frequency : " $1
   sed -i "/center_freq = /c\center_freq = $1" /openwebrx/config_webrx.py
fi
python /openwebrx/openwebrx.py


