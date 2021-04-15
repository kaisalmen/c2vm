#!/bin/bash

set -euo pipefail

echo -e "\nBuilding dynamic vhdx image:"
qemu-img convert ./staging/linux.img -O vhdx -o subformat=dynamic ./staging/linux.vhdx
