#!/bin/bash

# Check if zenity is installed as a dependency, if not, install it via pacman
if ! command -v zenity &> /dev/null; then
    sudo pacman -S --needed --noconfirm zenity
fi

# 1. Get User Confirmation
zenity --question \
    --title="Proton Launcher Installation" \
    --text="Proton Launcher will be installed on your system. Do you want to proceed?" \
    --width=400
    
if [ $? -ne 0 ]; then
    zenity --error --title="Cancelled" --text="Installation cancelled by the user."
    exit 1
fi

# 2. Password Entry Window (for sudo operations)
SUDO_PASS=$(zenity --password --title="Administrator Password Required")
if [ -z "$SUDO_PASS" ]; then
    zenity --error --title="Error" --text="No password entered, installation cancelled."
    exit 1
fi

# Main installation function (To pipe data into the progress bar)
(
    echo "10" ; echo "# Checking and installing dependencies..."
    echo "$SUDO_PASS" | sudo -S pacman -S --needed --noconfirm wget tar python curl &> /dev/null

    PROTON_DIR="$HOME/.local/share/proton-launcher"
    PREFIX_DIR="$PROTON_DIR/prefixes/default"
    mkdir -p "$PREFIX_DIR"

    if [ ! -d "$PROTON_DIR/proton-version" ]; then
        echo "30" ; echo "# Downloading the latest GE-Proton (This may take a while)..."
        LATEST_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | grep "browser_download_url.*tar.gz" | head -n 1 | cut -d '"' -f 4)
        
        wget -q "$LATEST_URL" -O "$PROTON_DIR/proton.tar.gz"
        
        echo "70" ; echo "# Extracting archive files..."
        tar -xf "$PROTON_DIR/proton.tar.gz" -C "$PROTON_DIR"
        
        EXTRACTED_DIR=$(find "$PROTON_DIR" -maxdepth 1 -type d -name "GE-Proton*")
        mv "$EXTRACTED_DIR" "$PROTON_DIR/proton-version"
        rm "$PROTON_DIR/proton.tar.gz"
    fi

    echo "85" ; echo "# Integrating commands into the system..."
    echo "$SUDO_PASS" | sudo -S cp proton-run /usr/local/bin/proton-run
    echo "$SUDO_PASS" | sudo -S chmod +x /usr/local/bin/proton-run

    echo "95" ; echo "# Adding Right-Click context menu entry..."
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

    update-desktop-database "$APP_DIR" 2>/dev/null
    
    echo "100" ; echo "# Installation completed successfully!"
) | zenity --progress \
           --title="Installing Proton Launcher" \
           --text="Starting installation..." \
           --percentage=0 \
           --auto-close \
           --no-cancel \
           --width=450

# Success Message Box
zenity --info \
    --title="Installation Completed" \
    --text="Proton Launcher has been successfully installed!\n\nNow you can right-click any .exe file and select 'Run with Proton'." \
    --width=400
