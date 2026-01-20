#!/data/data/com.termux/files/usr/bin/bash

# StorageClean v2.4.1 - Professional Android/Termux Cleanup Tool (Auto-Install)
# Fixed syntax, ANSI colors, GitHub compatibility + AUTO PACKAGE INSTALLATION
# Author: mdhhraj | Repo: mdhhraj/storageclean-package

set -euo pipefail

VERSION="2.4.1"
LOG_FILE="$HOME/storageclean.log"
REPO_URL="https://github.com/mdhhraj/storageclean-package"

# ANSI Colors (GitHub safe)
RED='\u001B[0;31m'; GREEN='\u001B[0;32m'; YELLOW='\u001B[1;33m'
BLUE='\u001B[0;34m'; PURPLE='\u001B[0;35m'; CYAN='\u001B[0;36m'; NC='\u001B[0m'

# Logging
log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

# Auto-install required packages
auto_install_packages() {
    echo -e "${BLUE}📦 Auto-installing required packages...${NC}"
    pkg update -y >/dev/null 2>&1
    pkg install -y coreutils findutils grep procps ncdu htop curl wget git >/dev/null 2>&1 || {
        echo -e "${RED}⚠️  Some packages failed to install. Continuing...${NC}"
    }
    log "✅ Required packages installed"
    echo -e "${GREEN}✅ Packages ready!${NC}
"
}

# Banner
banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${GREEN}              🔧 StorageClean v${VERSION} ${CYAN}║${NC}"
    echo -e "${CYAN}║${BLUE}             mdhhraj/storageclean-package                 ${CYAN}║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Storage analysis
analyze_storage() {
    echo -e "${BLUE}📊 Storage Analysis:${NC}"
    echo ""
    df -h "$PREFIX" | head -2
    echo ""
    echo -e "${YELLOW}📁 Top 10 largest in ~/:${NC}"
    du -ha ~/* 2>/dev/null | sort -hr | head -10 || echo "No files found"
    echo ""
}

# Cleanup functions
clean_termux_cache() {
    echo -e "${GREEN}🧹 Termux cache...${NC}"
    pkg autoclean >/dev/null 2>&1
    apt-get clean >/dev/null 2>&1
    rm -rf ~/.cache/* 2>/dev/null || true
    log "✅ Termux cache cleaned"
}

clean_tmp_files() {
    echo -e "${GREEN}🧹 Temporary files...${NC}"
    rm -rf /tmp/* 2>/dev/null || true
    find ~ -name "*.tmp" -delete 2>/dev/null || true
    log "✅ Temp files cleaned"
}

clean_logs() {
    echo -e "${GREEN}🧹 Old logs (>7 days)...${NC}"
    find ~ -name "*.log" -mtime +7 -delete 2>/dev/null || true
    log "✅ Old logs cleaned"
}

clean_downloads() {
    echo -e "${YELLOW}📥 Clean old APKs (>30 days)? (y/N): ${NC}"
    read -r choice
    [[ "$choice" =~ ^[Yy]$ ]] && {
        find ~/storage/downloads -name "*.apk" -mtime +30 -delete 2>/dev/null || true
        log "✅ Old APKs cleaned"
    }
}

# Self-update
self_update() {
    echo -e "${PURPLE}🔄 Updating...${NC}"
    curl -sL "$REPO_URL/raw/main/StorageClean.sh" -o "$HOME/StorageClean.sh.new" &&
    chmod +x "$HOME/StorageClean.sh.new" &&
    mv "$HOME/StorageClean.sh.new" "$0" &&
    log "✅ Updated to v$VERSION"
    echo -e "${GREEN}✅ Updated! Restart to use new version.${NC}"
}

# Menu
show_menu() {
    echo -e "${YELLOW}🧹 Choose:${NC}"
    echo "1) ${GREEN}Quick${NC} (cache+tmp)"
    echo "2) ${GREEN}Deep${NC} (cache+tmp+logs)"
    echo "3) ${GREEN}Full${NC} (all)"
    echo "4) ${BLUE}Analyze${NC}"
    echo "5) ${PURPLE}Update${NC}"
    echo "0) ${RED}Exit${NC}"
    echo -n "> "; read -r choice
}

# Main
main() {
    # AUTO INSTALL PACKAGES FIRST TIME
    auto_install_packages
    
    banner
    analyze_storage
    
    show_menu
    case $choice in
        1) clean_termux_cache; clean_tmp_files ;;
        2) clean_termux_cache; clean_tmp_files; clean_logs ;;
        3) clean_termux_cache; clean_tmp_files; clean_logs; clean_downloads ;;
        4) analyze_storage; read -r; return ;;
        5) self_update; read -r; return ;;
        0|*) echo -e "${GREEN}👋 Thanks!${NC}"; exit 0 ;;
    esac

    echo ""
    echo -e "${BLUE}📊 After:${NC}"; df -h "$PREFIX" | head -2
    echo -e "${GREEN}🎉 Done! Log: $LOG_FILE${NC}"
    log "🏁 StorageClean v$VERSION complete"
    read -r; main
}

main "$@"
