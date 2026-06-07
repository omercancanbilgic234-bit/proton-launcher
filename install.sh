#!/bin/bash

# Color codes for terminal output
GREEN='\033;32m'
BLUE='\033;34m'
NC='\033[0m'

echo -e "${BLUE}[*] Starting Proton Launcher Installation...${NC}"

# Install dependencies via pacman
echo -e "${BLUE}[*] Checking and installing dependencies...${NC}"
sudo pacman -S --needed --noconfirm wget tar python curl

# Create folder structure
PROTON_DIR="$HOME/.local/share/proton-launcher"
PREFIX_DIR="$PROTON_DIR/prefixes/default"
mkdir -p "$PREFIX_DIR"

# Download GE-Proton if not exists
if [ ! -d "$PROTON_DIR/proton-version" ]; then
    echo -e "${BLUE}[*] Downloading the latest GE-Proton (This may take a while)...${NC}"
    
    # Fetch latest release download URL from GitHub API
    LATEST_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep "browser_download_url.*tar.gz" | head -n 1 | cut -d '"' -f 4)
    
    wget -q --show-progress "$LATEST_URL" -O "$PROTON_DIR/proton.tar.gz"
    
    echo -e "${BLUE}[*] Extracting archive...${NC}"
    tar -xf "$PROTON_DIR/proton.tar.gz" -C "$PROTON_DIR"
    
    # Rename folder for easier script handling
    EXTRACTED_DIR=$(find "$PROTON_DIR" -maxdepth 1 -type d -name "GE-Proton*")
    mv "$EXTRACTED_DIR" "$PROTON_DIR/proton-version"
    rm "$PROTON_DIR/proton.tar.gz"
fi

# Install the runner script to system PATH
echo -e "${BLUE}[*] Integrating commands into the system...${NC}"
sudo cp proton-run /usr/local/bin/proton-run
sudo chmod +x /usr/local/bin/proton-run

# Create Right-Click (Desktop Entry) Integration
echo -e "${BLUE}[*] Adding Right-Click context menu entry...${NC}"
APP_DIR="$HOME/.local/share/applications"
mkdir -p "$APP_DIR"

cat <<EOF > "$APP_DIR/proton-launcher.desktop"
[Desktop Entry]
Type=Application
Name=Run with Proton
Comment=Launch Windows EXEs using GE-Proton
Exec=/usr/local/bin/proton-run %f
MimeType=application/x-ms-dos-executable;application/x-msdownload;application/x-executable;
Icon=steam
Terminal=false
Categories=Utility;
NoDisplay=false
EOF

# Update desktop database to register the new mime handler
update-desktop-database "$APP_DIR" 2>/dev/null

echo -e "${GREEN}[+] Installation completed successfully!${NC}"
echo -e "${GREEN}[+] You can now right-click any .exe file and select 'Run with Proton'${NC}"
echo -e "${GREEN}[+] Or run it via terminal: proton-run /path/to/app.exe${NC}"
