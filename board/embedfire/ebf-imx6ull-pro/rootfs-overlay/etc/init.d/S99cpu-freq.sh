#!/bin/bash

# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor  

echo 792000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed

# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq 
