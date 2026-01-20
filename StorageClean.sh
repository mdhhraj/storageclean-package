#!/data/data/com.termux/files/usr/bin/bash
echo "🔧 StorageClean - Android/Termux Cleanup Tool"
echo "============================================"

# Package cache cleanup
echo "🧹 Cleaning package caches..."
pkg clean && apt clean
rm -rf $PREFIX/var/cache/apt/archives/*.deb

# Temp files
echo "🧹 Cleaning temp files..."
rm -rf $TMPDIR/* /tmp/*

# User caches (safe)
echo "🧹 Cleaning user caches..."
rm -rf ~/.cache/* 
find $HOME -name "*.tmp" -delete 2>/dev/null

echo "✅ DONE! Check space:"
df -h $PREFIX
