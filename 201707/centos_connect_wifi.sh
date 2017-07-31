#!/bin/bash


########
##    1、查看无线网卡口 iw dev (这里是wlp3s0)
##    2、wpa_passphrase wifi_name "wifi_pass" > /etc/wpa_supplicant/wpa_supplicant.conf
########

wpa_supplicant -i wlp3s0 -c /etc/wpa_supplicant/wpa_supplicant.conf -D wext -B
ip link set wlp3s0 up
dhclient wlp3s0
