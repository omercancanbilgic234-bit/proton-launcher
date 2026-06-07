# Arch Linux - Proton Launcher

A lightweight tool for Arch Linux to run any Windows `.exe` file directly using **Valve's Proton (GE-Proton)** without needing to add it to Steam or mess with complex Wine prefixes[cite: 5]. 

It also adds a handy **Right-Click "Run with Proton"** option to your file manager[cite: 5].

## Features
* **Automated Setup:** Automatically downloads and configures the latest GE-Proton.
* **Clean Prefix Management:** Pre-configured and isolated Wine prefix environment.
* **Terminal Integration:** Run apps quickly via terminal using `proton-run app.exe`.
* **Desktop Integration:** Right-click any `.exe` file -> Run with Proton.
* **Dual Installation Modes:** Install via Graphical User Interface (GUI) or standard Terminal.

---

## Installation

First, clone the repository and navigate into the project directory[cite: 5]:
```bash
git clone [https://github.com/omercancanbilgic234-bit/proton-launcher.git](https://github.com/omercancanbilgic234-bit/proton-launcher.git)
cd proton-launcher

Choose one of the installation methods below to proceed:
Method 1: Graphical User Interface (GUI) Installation

Perfect for a quick, terminal-free installation with a visual progress bar.

    Right-click on install_gui.sh and open Properties.

    Go to the Permissions tab and check "Allow executing file as program" (or run chmod +x install_gui.sh in your terminal).

    Double-click install_gui.sh and select Run.

    Click Yes on the confirmation dialog.

    Enter your administrator (sudo) password when prompted.

    Wait for the progress bar to complete (it will automatically download and extract the latest GE-Proton).

    Click OK on the success message box.

Method 2: Terminal Installation

For those who prefer the standard command-line interface.

    Give execution permissions to the installation scripts:

Bash

   chmod +x install.sh proton-run

    Run the installer script:

Bash

   ./install.sh

    Enter your sudo password and wait for the process to finish.

How to Use

Once the installation is complete successfully, you can launch your Windows applications in two different ways:
1. Via File Manager (Right-Click)

    Open your preferred file manager (Thunar, Dolphin, Nautilus, etc.).

    Right-click any Windows .exe file.

    Select "Run with Proton" from the context menu.

2. Via Terminal

    Open your terminal and pass the path of the executable file to proton-run:

Bash

  proton-run /path/to/your/application.exe

Requirements

    An Arch Linux-based distribution (Arch Linux, Manjaro, EndeavourOS, Garuda, etc.)

    Active internet connection (required to fetch the latest GE-Proton release package from GitHub)
