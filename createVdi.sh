#!/bin/bash

set -euo pipefail

echo -e "\nBuilding non-static vdi image:"
qemu-img convert ./staging/linux.img -O vdi -o static=off ./staging/linux.vdi