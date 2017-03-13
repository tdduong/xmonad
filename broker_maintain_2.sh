#/bin/sh
if [ -d "/home/tduong/.wine/drive_c/Program Files/AmiBroker" ] ; then
	mv "/home/tduong/.wine/drive_c/Program Files/AmiBroker" /data/00-AmiData/Amibroker_Maintain/
 	echo "Data Ami is moved"
else
	echo "There is no data here! Please check again"	
fi

if [ -d "/home/tduong/.wine/drive_c/Program Files/thinkorswim" ] ; then
        mv "/home/tduong/.wine/drive_c/Program Files/thinkorswim" /data/00-AmiData/Amibroker_Maintain                                                                                                               
        echo "Data thinkorswim is moved"
else
        echo "There is no data here! Please check again"        
fi

if [ -d  "/home/tduong/.wine/" ] ; then
	rm -rf "/home/tduong/.wine/"
else
	echo "Wine is removed"
fi
WINEARCH=win32 WINEPREFIX=~/.wine winecfg
winetricks mfc42
winetricks mfc42 
if [ -d  "/home/tduong/.wine/drive_c/Program Files/" ] ; then
	cp -rf "/data/00-AmiData/Amibroker_Maintain/AmiBroker/" "/home/tduong/.wine/drive_c/Program Files/"
	echo "Amibroker Maintain is completed"
fi
