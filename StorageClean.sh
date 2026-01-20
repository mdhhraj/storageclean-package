#!/data/data/com.termux/files/usr/bin/bash
# SPDX-License-Identifier: GPL-3.0-or-later
# Copyright (C) 2026 Md. Hasibul Hasan <mdhhraj@outlook.com>
# StorageClean v2.6.3 - mdhhraj/storageclean-package
VERSION="2.6.3"
RED='\u001B[0;31m'; GREEN='\u001B[0;32m'; YELLOW='\u001B[1;33m'; NC='\u001B[0m'

echo -e "${GREEN}🔧 StorageClean v${VERSION}${NC}"
df -h "$PREFIX" | head -2
echo "1)clean 2)dclean 3)fix 4)package"
read choice
case $choice in 
1)pkg autoclean;rm -rf ~/.cache/*;;
2)find ~ -name "*.log" -delete 2>/dev/null;;
3)pkg upgrade -y;;
4)echo "coreutils findutils curl git ncdu htop";;
esac
echo -e "${GREEN}✅ Done v${VERSION}!${NC}"