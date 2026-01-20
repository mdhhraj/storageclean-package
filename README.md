# StorageClean v2.1.0
**Termux Storage Cleaner**

## 🚀 Termux Install (Correct Way)
```bash
# Method 1: Direct script (RECOMMENDED)
curl -s https://raw.githubusercontent.com/mdhhraj/storageclean-package/main/StorageClean.sh | bash

# Method 2: Manual install  
mkdir -p $PREFIX/usr/bin
curl -s https://raw.githubusercontent.com/mdhhraj/storageclean-package/main/StorageClean.sh > $PREFIX/usr/bin/StorageClean
chmod +x $PREFIX/usr/bin/StorageClean
StorageClean
