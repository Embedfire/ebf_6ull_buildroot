#!/bin/sh
#clear
#ppp-on.sh
OPTION_FILE="ec20_options"
DIALER_SCRIPT="ec20_ppp_dialer"
pppd file $OPTION_FILE connect '/usr/sbin/chat -v -f ec20_ppp_dialer' &


