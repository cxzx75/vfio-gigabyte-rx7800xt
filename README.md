# VFIO GPU Passthrough: Getting the Gigabyte RX 7800 XT to work

This is not a full setup tutorial, there are plenty of resources for that already. Instead, it’s about what i did to get my Gigabyte RX 7800 XT working with VFIO GPU passthrough, and some performance tips and workarounds i found.

---

## My setup

- CPU: Ryzen 7 5700X
- Host GPU: MSI R7 370 
- Guest GPU: Gigabyte RX 7800 XT
- Motherboard: MSI B550-A PRO | BIOS version: A.J0
- Kernel: 6.8
- OS: Linux Mint 22.2

### Host BIOS config
- Above 4G decoding: Enabled
- Resizable BAR: Enabled
- CSM/Legacy boot: Disabled

---

## The reset bug workaround

Guides i found for working around the reset bug didn’t work for me, disabling ROM BAR and/or using a dummy VBIOS didn’t stop the host from crashing on VM shutdown, although it did prevent the host from crashing on VM startup. What worked for me was:

- Close all programs in the guest OS.

- Unbind the GPU from the VFIO driver with unbind.sh (run as root)

- Shut down the VM

- If needed, rebind the GPU to vfio-pci with rebind.sh (run as root)

---

## AMD drivers in the guest

AMD drivers fail to load on Windows VMs without a `vendor_id`. Set it in the Hyper-V features block to match your host CPU vendor:

- For AMD: `<vendor_id state="on" value="AuthenticAMD"/>`
- For Intel: `<vendor_id state="on" value="GenuineIntel"/>`

---

## Performance observations

### Hypervisor flag

The `<feature policy="disable" name="hypervisor"/>` flag hides the HV flag in CPUID which is useful for running anti-VM software. However, this flag kills performance in CPU-heavy games like Cyberpunk 2077. After i removed the flag, the average FPS in that game went from ~30 to ~110.

### USB mouse polling rate

If you pass through a USB mouse with a high polling rate (like the Logitech G502), you might notice lag, especially in games. This is likely due to the emulated QEMU USB controller not handling high polling rates well. Lower the polling rate to under ~500Hz to avoid lag.

---

## Power management note

When the GPU is assigned to a VM via VFIO, the Linux host no longer controls its power management, and normally, the AMD driver in the guest OS is responsible for that instead, but during idle phases (e.g., before the VM boots or after VM shutdown), no driver may be actively managing power, leading to unnecessary heat and power draw.

To reduce idle power consumption, enable PCIe ASPM in your BIOS.
