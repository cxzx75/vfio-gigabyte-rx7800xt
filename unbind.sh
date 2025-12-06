#!/bin/bash
# Unbind Gigabyte 7800XT GPU and audio
echo "Unbinding GPU"
echo "0000:2d:00.0" > /sys/bus/pci/devices/0000:2d:00.0/driver/unbind

echo "Unbinding GPU audio"
echo "0000:2d:00.1" > /sys/bus/pci/devices/0000:2d:00.1/driver/unbind
