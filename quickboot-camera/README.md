
# Quickboot Camera Optimizations for IQ-9075 EVK

This package provides services, rules, and kernel module configurations to optimize the camera boot time (Time-to-First-Frame) on the IQ-9075 EVK.

## First Boot Setup (Mandatory)

After flashing the image and booting the IQ-9075 EVK for the first time, you **must** manually run the camera setup script to initialize the EFI variables and remove unused sensor binaries. This step is required for the camera to function correctly and optimally.

Execute the following command manually on the device after first boot:
```bash
/usr/bin/iq9075-first-boot-cam-setup.sh
