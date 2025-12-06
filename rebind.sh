#!/bin/bash
# Rebind Gigabyte 7800XT GPU and audio to vfio-pci
echo "Rebinding GPU to vfio-pci"
echo "vfio-pci" > /sys/bus/pci/devices/0000:2d:00.0/driver_override
echo "0000:2d:00.0" > /sys/bus/pci/drivers_probe

echo "Rebinding GPU audio to vfio-pci"
echo "vfio-pci" > /sys/bus/pci/devices/0000:2d:00.1/driver_override
echo "0000:2d:00.1" > /sys/bus/pci/drivers_probe
