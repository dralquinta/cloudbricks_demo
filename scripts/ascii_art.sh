# Copyright (c) 2021 Oracle and/or its affiliates.
#!/bin/sh
# All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl
# ascii_art.sh 
#
# Purpose: This script adds ASCII art to login in ubuntu
set +x

echo "[1/2] Install Boxes"
sudo apt-get install boxes -y
echo "[1/2] Done"

echo "[2/2] Add entry into .bashrc"
echo "boxes -a c -d mouse <<< \"Hello $1. Youre now logged as user: $USER,today is \$(date)\"" | tee -a /home/ubuntu/.bashrc
echo "[2/2] Done"