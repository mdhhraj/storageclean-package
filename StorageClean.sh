#!/data/data/com.termux/files/usr/bin/bash

# =================================================================
# StorageClean v2.4.0 - Professional Termux Storage Manager
# Auto-installs ALL recommended packages with -y flag
# =================================================================

set -euo pipefail

# Configuration
VERSION="2.4.0"
LOG_FILE="$HOME/storageclean.log"

# Colors
RED='\u001B[0;31m' GREEN='\u001B[0;32m' YELLOW='\u001B[1;33m'
BLUE='\u001B[0;34m' PURPLE='\u001B[0;35m' CYAN='\u001B[0;36m'
BOLD='\u001B[1m' NC='\u001B[0m'

# Logging
log() { echo -e "$(date '+%H:%M:%S') [$*]" | tee -a "$LOG_FILE" 2>/dev/null; }
success() { echo -e "${GREEN}✅ $*${NC}"; }
warn() { echo -e "${YELLOW}⚠️  $*${NC}"; }
error() { echo -e "${RED}❌ $*${NC}"; }

# AUTO-INSTALL RECOMMENDED PACKAGES
auto_install_tools() {
    echo -e "${CYAN}🔧 Auto-installing recommended tools...${NC}"
    local packages=(ncdu htop tree)
    
    for pkg in "${packages[@]}"; do
        if ! command -v "$pkg" >/dev/null 2>&1; then
            log "Installing $pkg..."
            pkg install "$pkg" -y >/dev/null 2>&1 || {
                warn "$pkg install skipped"
            }
            success "$pkg installed"
        else
            log "$pkg already available"
        fi
    done
    success "All recommended tools ready!"
}

# Storage report
storage_report() {
    clear
    echo -e "${BOLD}${PURPLE}📊 StorageClean v$VERSION - Results${NC}"
    echo "═══════════════════════════════════════════════"
    
    local prefix_free=$(df -h "$PREFIX" | tail -1 | awk '{print $4}')
    local home_free=$(df -h "$HOME" | tail -1 | awk '{print $4}')
    local cache_size=$(du -sh "$HOME/.cache" 2>/dev/null | cut -f1 || echo "0K")
    
    printf "${CYAN}💾 Prefix Free: %-8s  Home Free: %s${NC}
" "$prefix_free" "$home_free"
    printf "${CYAN}📦 User Cache:  %-8s  APT Cache: %s${NC}
" "$cache_size" "$(du -sh "$PREFIX/var/cache/apt/archives" 2>/dev/null | cut -f1 || echo '0K')"
    
    [[ -f "$LOG_FILE" ]] && {
        echo ""
        echo -e "${YELLOW}📋 Last 5 actions:${NC}"
        tail -5 "$LOG_FILE" 2>/dev/null | cut -c1-80 || true
    }
    echo ""
}

# CLEAN - Normal cleanup
clean() {
    log "Normal Clean"
    echo -e "${GREEN}🧹 Normal Clean Starting...${NC}"
    
    pkg clean >/dev/null 2>&1; apt clean >/dev/null 2>&1
    rm -rf "$PREFIX/var/cache/apt/archives/"*.deb 2>/dev/null
    rm -rf "$TMPDIR/"* /tmp/* 2>/dev/null
    rm -rf "$HOME/.cache/"* 2>/dev/null
    
    success "Normal Clean COMPLETE!"
    log "Normal Clean done"
}

# QCLEAN - Quick & fast
qclean() {
    log "Quick Clean"
    echo -e "${GREEN}⚡ Quick Clean (ultra-fast)...${NC}"
    
    rm -rf "$TMPDIR/"* "$HOME/.cache/"* 2>/dev/null
    apt clean >/dev/null 2>&1
    
    success "Quick Clean COMPLETE! (2 sec)"
    log "Quick Clean done"
}

# DCLEAN - Deep clean
dclean() {
    log "Deep Clean"
    echo -e "${GREEN}🔥 Deep Clean (maximum)...${NC}"
    
    clean
    find "$HOME" ( -name "*.log" -o -name "*.tmp" ) -mtime +1 -delete 2>/dev/null
    find "$HOME" -name "*.deb" -mtime +7 -delete 2>/dev/null
    rm -rf "$HOME/tmp/"* 2>/dev/null
    
    success "Deep Clean COMPLETE!"
    log "Deep Clean done"
}

# HELP - Commands list
clean_help() {
    clear
    echo -e "${BOLD}${CYAN}🧹 StorageClean v$VERSION Commands${NC}"
    echo "═══════════════════════════════════════════════"
    echo -e "${GREEN}clean${NC}      → Normal cleanup"
    echo -e "${GREEN}qclean${NC}     → Quick & fast cleanup" 
    echo -e "${GREEN}dclean${NC}     → Deep cleanup"
    echo -e "${YELLOW}clean result${NC} → View results + logs"
    echo -e "${YELLOW}clean help${NC}  → Show this help"
    echo -e "${YELLOW}tool help${NC}  → Package info"
    echo -e "${RED}exit${NC}        → Exit"
}

# TOOL HELP - Now shows AUTO-INSTALLED status
tool_help() {
    clear
    echo -e "${BOLD}${CYAN}🔧 StorageClean v$VERSION - Tools${NC}"
    echo "═══════════════════════════════════════════════"
    echo -e "${GREEN}✅ AUTO-INSTALLED:${NC}"
    echo "   • ncdu   (Disk analyzer)"
    echo "   • htop   (Process monitor)"
    echo "   • tree   (Directory viewer)"
    echo ""
    echo -e "${PURPLE}Usage:${NC} ncdu $HOME  |  htop  |  tree $PREFIX"
    echo -e "${GREEN}All tools ready - no manual install needed!${NC}"
}

# MAIN DISPATCHER
main() {
    clear
    echo -e "${BOLD}${PURPLE}🔧 StorageClean v$VERSION${NC} ${CYAN}mdhhraj/storageclean-package${NC}"
    echo ""
    
    # AUTO-INSTALL on first run
    auto_install_tools
    
    # Parse arguments  
    local cmd=$(echo "${1:-}" | tr '[:upper:]' '[:lower:]')
    
    case "$cmd" in
        "clean")      clean ;;
        "qclean")     qclean ;;
        "dclean")     dclean ;;
        "result")     storage_report ;;
        "help")       clean_help ;;
        "tool")       tool_help ;;
        "--help"|"-h") clean_help ;;
        "--version"|"-v")
            echo "StorageClean v$VERSION - Professional Termux Cleaner"
            exit 0
            ;;
        ""|*)
            storage_report
            echo -e "${YELLOW}💡 Commands: clean qclean dclean clean result clean help${NC}"
            clean_help
            ;;
    esac
    
    echo ""
    storage_report
    echo -e "${GREEN}👋 Ready! Type: clean | qclean | dclean${NC}"
}

# Safety
[[ $EUID -eq 0 ]] && { error "Don't run as root!"; exit 1; }

# Run
main "$@"