#!/bin/bash
# This script change your default port HTTP for 81
# Colaboration: Alexandre Jeronimo Correa - Onda Internet, PVi1 (Git user)
FILE=/etc/persistent/mf.tar

# Check virus
if [ -e "$FILE" ] ; then
    echo "Infected :("
    #Acess folder
    cd /etc/persistent
    #Remove the virus
    rm mf.tar
    rm -Rf .mf
    rm -Rf mcuser
    #rm rc.poststart
    # Preserve ISP custom scripts Colaboration PVi1 (Git user)
    sed -i '/mf\/mother/d' /etc/persistent/rc.poststart
    rm rc.prestart
    #Remove mcuser in passwd - by Alexandre
    sed -ir '/mcad/ c ' /etc/inittab
    sed -ir '/mcuser/ c ' /etc/passwd
    sed -ir '/mother/ c ' /etc/passwd
    #Change HTTP port for 81 | Need access http://IP:81
    cat /tmp/system.cfg | grep -v http > /tmp/system2.cfg
    echo "httpd.https.status=disabled" >> /tmp/system2.cfg
    echo "httpd.port=81" >> /tmp/system2.cfg
    echo "httpd.session.timeout=900" >> /tmp/system2.cfg
    echo "httpd.status=enabled" > /tmp/system2.cfg
    cat /tmp/system2.cfg >> /tmp/system.cfg
    rm /tmp/system2.cfg
    #Write new config
    cfgmtd -w -p /etc/
    cfgmtd -f /tmp/system.cfg -w
    #Kill process - by Alexandre
    kill -HUP `/bin/pidof init`
    kill -9 `/bin/pidof mcad`
    kill -9 `/bin/pidof init`
    kill -9 `/bin/pidof search`
    kill -9 `/bin/pidof mother`
    kill -9 `/bin/pidof sleep`
    echo "Clear Completed :)"
    echo "Upgrade firmware"
    if [ "$versao" == "XM" ]; then
        URL='http://www.ubnt.com/downloads/XN-fw-internal/v5.6.5/XM.v5.6.5.29033.160515.2119.bin'
        wget $URL -O /tmp/XM.v5.6.5.29033.160515.2119.bin
        ubntbox fwupdate.real -m /tmp/XM.v5.6.5.29033.160515.2119.bin
    fi
    if [ "$versao" == "XW" ]; then
        URL='http://www.ubnt.com/downloads/XN-fw-internal/v5.6.5/XW.v5.6.5.29033.160515.2108.bin'
        wget $URL /tmp/XW.v5.6.5.29033.160515.2108.bin
        ubntbox fwupdate.real -m /tmp/XW.v5.6.5.29033.160515.2108.bin
    fi

    #reboot
else
    echo "Clear :) No actions"
    exit
fi
