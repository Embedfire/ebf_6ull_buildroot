#!/bin/bash

set +m

function Usage()
{
	echo -e "\033[33m The test bases on zImage-imx6ull-14x14-evk-<device>-50-70-dht11-leds.dtb \033[0m"

	echo -e "\033[37m [1] LED_TEST\033[0m"
	echo -e "\033[37m [2] KEY_TEST\033[0m"
	echo -e "\033[37m [3] BEEP_TEST\033[0m"
	echo -e "\033[37m [4] NET_TEST\033[0m"
	echo -e "\033[37m [5] AUDIO_TEST\033[0m"
	echo -e "\033[37m [6] USBHUB_TEST\033[0m"
	echo -e "\033[37m [7] ADC_TEST\033[0m"
	echo -e "\033[37m [8] GYRO_TEST\033[0m"
	echo -e "\033[37m [9] WIFI_TEST\033[0m"
	echo -e "\033[37m [a] ALL_TEST\033[0m"
	echo -e "\033[37m [h] Help\033[0m"
	echo -e "\033[37m [q] Exit\033[0m"
}

#网络测试
res_eth0=true
res_eth1=true
function net_test()
{
    ifconfig eth0 up
    ifconfig eth1 up

    udhcpc -b -i eth0
    udhcpc -b -i eth1

    ping -I eth0 -c 5 192.168.0.217
    if [ $? -ne 0 ]
    then
        echo -e "\033[31m[ERROR] ETH0_TEST:Faile to ETH0 Test \033[0m"
        res_eth0=false
    else
        echo -e "\033[32m[SUCCESS] ETH0 OK \033[0m"
    fi
    ping -I eth1 -c 5 192.168.0.217
    if [ $? -ne 0 ]
    then
        echo -e "\033[31m[ERROR] ETH1_TEST:Faile to ETH1 Test \033[0m"
        res_eth1=false
    else
        echo  -e "\033[32m[SUCCESS] ETH1 OK \033[0m"
    fi

}

# 蜂鸣器测试
function beep_test()
{
    echo 19 > /sys/class/gpio/export

    echo 'out' > /sys/class/gpio/gpio19/direction

    echo 1 > /sys/class/gpio/gpio19/value

    sleep 1s

    echo 0 > /sys/class/gpio/gpio19/value

    echo 19 > /sys/class/gpio/unexport
}
res_usbhub=true
function usbhub_test()
{
    cat /proc/bus/input/devices | grep -n '[Uu][Ss][Bb]'
    if [ $? == 1 ] ;
    then
        echo  -e "\033[31m [ERROR] USBHUB_TEST:Faile to USB_HUB Test \033[0m"
				res_usbhub=false
    else
        echo  -e "\033[32m [SUCCESS] USB_HUB OK \033[0m"
    fi
}

kill_alive() {
#	if [ -e /proc/$KEEP_ALIVE_PID ] ; then
#		echo $!
#		echo $KEEP_ALIVE_PID
#		echo "exist"
#		kill -9 $!
#		res=false
#	fi
	#kill $!
	return 0
}


res_wifi=true
function wifi_test()
{
    rfkill unblock all
    ifconfig wlan0 up
    wpa_passphrase embedfire2 wildfire > wifi.conf
    wpa_supplicant -B -c wifi.conf -iwlan0
    udhcpc -b -i wlan0

     ping -I wlan0 -c 5 192.168.0.169
    if [ $? -ne 0 ]
    then
        echo -e "\033[31m [ERROR] WIFI_TEST:Faile to WIFI Test \033[0m"

        res_wifi=false;
    else
        echo  -e "\033[32m [SUCCESS] WIFI OK \033[0m"
    fi   
}


function report()
{
	echo "ALL TEST RESULT :"
	echo "    KEY    ------------------ $1"
	echo "    ETH0   ------------------ $2"
	echo "    ETH1   ------------------ $3"
	echo "  USB_HUB  ------------------ $4"
	echo "    WIFI   ------------------ $5"

}

# 按键测试
res_key=true
function key_test()
{
	$path../input.sh
  if [ $? -ne 0 ]
  then
      echo -e "\033[31m [ERROR] KEY_TEST:Faile to KEY Test \033[0m"
      res_key=false;
     
  fi
}

function led_test()
{
	echo 255 > /sys/class/leds/red/brightness
	echo 255 > /sys/class/leds/green/brightness
	echo 255 > /sys/class/leds/blue/brightness
}


function check_dir()
{
#	if [ `pwd | awk -F "/" '{print $NF}'` == "all_test" ];
#	then
#		path=
#	elif [ `pwd| awk -F "/" '{print $NF}'`  == "peripheral" ];
#	then
#		path=`pwd`/all_test/
#	else
#		echo -e "\033[31m [ ERROR ] please run the script in the 'peripheral' directory !\033[0m"
#		exit 1
#	fi 
	path=`cd $(dirname $0); pwd`/
	return 0
}


while true
do
	check_dir
	Usage
#	echo $path
	
#	report $res_key $res_eth0 $res_eth1 $res_wifi $res_usbhub 
	read -p "Please enter the test index : " input
	case $input in
	1) 
	# 捕获中断信号
	trap "kill_alive" 2
	$path../led.sh
	trap - 2
  ;;
	2) 
	trap "kill_alive" 2
	$path../input.sh
	trap - 2
	;;
  3) 
	trap "kill_alive" 2
	$path../beep.sh
	trap - 2
  ;; 
  4) 
	trap "kill_alive" 2
	net_test
	trap - 2
  ;;
	5)
	trap "kill_alive" 2
	$path../music_player.sh
	trap - 2	
	;;
	6)
	trap "kill_alive" 2
	usbhub_test
	trap - 2	
	;;
  7) 
	trap "kill_alive" 2
	$path../adc.sh
	trap - 2
  ;;	
  8) 
	trap "kill_alive" 2
	$path../mpu_demo
	trap - 2
  ;;
	9)
	trap "kill_alive" 2
	wifi_test
	trap - 2
	;;
	a)
	trap "kill_alive" 2
	led_test
	key_test
	beep_test
	net_test
	$path../music_player.sh
	usbhub_test
	$path../adc.sh
	$path../mpu_demo
	wifi_test
	report $res_key $res_eth0 $res_eth1 $res_usbhub $res_wifi
	trap - 2
	;;
  q) exit 0
  ;;
  *) echo -e "\033[31m[ ERROR ] Invalid  parameter : $input , Please Retry...\033[0m"
  ;;
  esac	
	
done

