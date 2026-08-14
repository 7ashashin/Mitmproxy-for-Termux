#!/data/data/com.termux/files/usr/bin/bash

set -e

echo "======================================"
echo "   mitmproxy installer for Termux"
echo "======================================"

# Update Termux
echo "[1/6] Updating Termux..."
pkg update -y
pkg upgrade -y

# Install required Termux packages
echo "[2/6] Installing dependencies..."
pkg install -y proot-distro

# Install Debian if it doesn't already exist
echo "[3/6] Checking Debian..."

if ! proot-distro list 2>/dev/null | grep -q "debian.*installed"; then
    echo "Installing Debian..."
    proot-distro install debian
else
    echo "Debian already installed."
fi

# Create installation script inside Debian
echo "[4/6] Preparing Debian environment..."

cat > "$PREFIX/tmp-install-mitmproxy.sh" <<'EOF'
#!/bin/bash

set -e

echo "======================================"
echo "   Installing mitmproxy in Debian"
echo "======================================"

apt update

apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    ca-certificates \
    curl \
    wget \
    git

echo "[5/6] Creating Python virtual environment..."

python3 -m venv "$HOME/mitm-env"

source "$HOME/mitm-env/bin/activate"

python -m pip install --upgrade pip setuptools wheel

echo "[6/6] Installing mitmproxy..."

python -m pip install mitmproxy

echo
echo "======================================"
echo " mitmproxy installation complete!"
echo "======================================"
echo
echo "Start mitmweb with:"
echo
echo "  source ~/mitm-env/bin/activate"
echo "  mitmweb --web-host 127.0.0.1"
echo
echo "Web interface:"
echo "  http://127.0.0.1:8081"
echo
EOF

# Run installer inside Debian
echo "[5/6] Entering Debian..."

proot-distro login debian -- bash /data/data/com.termux/files/usr/tmp-install-mitmproxy.sh

# Cleanup
rm -f "$PREFIX/tmp-install-mitmproxy.sh"

echo
echo "======================================"
echo " Installation finished!"
echo "======================================"
echo
echo "Start Debian:"
echo "  proot-distro login debian"
echo
echo "Then start mitmproxy:"
echo "  source ~/mitm-env/bin/activate"
echo "  mitmweb --web-host 127.0.0.1"
echo
