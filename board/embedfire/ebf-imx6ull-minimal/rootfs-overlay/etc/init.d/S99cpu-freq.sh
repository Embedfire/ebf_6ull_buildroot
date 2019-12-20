#!/bin/bash

echo userspace > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor  

echo 792000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed

