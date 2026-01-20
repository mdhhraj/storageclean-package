#!/data/data/com.termux/files/usr/bin/bash
# StorageClean v2.6.3 - FIXED Menu + Colors + Global
VERSION="2.6.3"

# TRADITIONAL COLORS (Termux compatible)
RED='\u001B[0;31m'; GREEN='\u001B[0;32m'; YELLOW='\u001B[1;33m'
BLUE='\u001B[0;34m'; PURPLE='\u001B[0;35m'; CYAN='\u001B[0;36m'; NC='\u001B[0m'

banner() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  🔧 StorageClean v${VERSION}           ║${NC}"
    echo -e "${CYAN}║  mdhhraj/storageclean-package        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════╝${NC}"
}

main_menu() {
    echo -e "${BLUE}📊 Storage Analysis:${NC}"
    df -h "$PREFIX" | head -2
    echo ""
    echo -e "${YELLOW}📁 Top files:${NC}"
    du -sh ~/* 2>/dev/null | sort -hr | head -6
    echo ""
    echo -e "${YELLOW}🧹 Choose:${NC}"
    echo "1) ${GREEN}Normal${NC}  2) ${GREEN}Deep${NC}"
    echo "3) ${PURPLE}Fix${NC}   4) ${BLUE}Packages${NC}"
    echo "0) Menu"
    echo -n "> "; read -r choice
    case $choice in 
        1) clean_normal ;; 2) clean_deep ;; 3) fix_issues ;; 
        4) show_packages ;; 0) sc ;; *) echo -e "${RED}Invalid${NC}";;
    esac
}

clean_normal() { echo -e "${GREEN}🧹 Normal clean...${NC}"; pkg autoclean; rm -rf ~/.cache/* /tmp/*; }
clean_deep() { echo -e "${GREEN}🧹 Deep clean...${NC}"; clean_normal; find ~ -name "*.log" -delete 2>/dev/null; }
fix_issues() { echo -e "${PURPLE}🔧 Fixing...${NC}"; pkg autoclean; pkg upgrade -y; rm -rf ~/.cache/*; }
show_packages() { echo -e "${GREEN}📦 Packages: coreutils findutils curl git ncdu htop${NC}"; }

sc() { banner; main_menu; }
clean() { ~/StorageClean.sh clean; }
dclean() { ~/StorageClean.sh dclean; }
fix() { ~/StorageClean.sh fix; }
package() { ~/StorageClean.sh package; }

# AUTO-RUN based on argument
case "${1:-sc}" in
    sc|menu|"") sc ;;
    clean|c) clean_normal ;;
    dclean|deep|d) clean_deep ;;
    fix|f) fix_issues ;;
    package|p) show_packages ;;
esac

echo -e "${GREEN}🎉 Done!${NC}"
df -h "$PREFIX" | head -2
