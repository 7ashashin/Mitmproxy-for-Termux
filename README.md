# Mitmproxy for Android

Install and run **mitmproxy** on Android through Termux using a Debian
userspace and a Python virtual environment.

This approach avoids trying to compile `mitmproxy_rs` directly against
Termux's Android Python environment.

## Requirements

-   Android device
-   Termux
-   Internet connection
-   ARM64 devices are supported by the Debian/Termux setup
-   For HTTPS interception, install and trust the mitmproxy CA only on
    devices/traffic you own or are authorized to test

## Installation

Clone or copy the project into Termux, then run:

``` bash
chmod +x install-mitmproxy.sh
./install-mitmproxy.sh
```

The installer:

1.  Updates Termux packages.
2.  Installs `proot-distro`.
3.  Installs Debian.
4.  Installs Python, pip, and virtual-environment support.
5.  Creates `~/mitm-env`.
6.  Installs mitmproxy inside the virtual environment.

## Starting mitmproxy

Enter Debian:

``` bash
proot-distro login debian
```

Activate the environment:

``` bash
source ~/mitm-env/bin/activate
```

Start the web interface:

``` bash
mitmweb --web-host 127.0.0.1
```

Open the interface in your Android browser:

``` text
http://127.0.0.1:8081
```

The proxy normally listens on:

``` text
127.0.0.1:8080
```

## HTTPS interception

With mitmproxy running, open:

``` text
http://mitm.it
```

Install the Android CA certificate and then configure your
browser/device to use the proxy.

Modern Android apps may not trust user-installed CAs, and some
applications use certificate pinning. A browser is usually the simplest
environment for authorized CTF testing.

## Quick launcher

After installation, you can create a launcher in Termux:

``` bash
cat > ~/start-mitm.sh <<'EOF'
#!/data/data/com.termux/files/usr/bin/bash

proot-distro login debian -- bash -c '
source ~/mitm-env/bin/activate
mitmweb --web-host 127.0.0.1
'
EOF

chmod +x ~/start-mitm.sh
```

Then start mitmweb with:

``` bash
~/start-mitm.sh
```

## Troubleshooting

### `No module named mitmproxy_rs`

Do not install mitmproxy with:

``` bash
pip install mitmproxy --no-deps
```

That skips required dependencies.

Instead, install mitmproxy inside the Debian environment created by this
project.

### Check the installation

Inside Debian:

``` bash
source ~/mitm-env/bin/activate
mitmproxy --version
```

You can also check:

``` bash
which mitmproxy
python --version
```

## Project structure

``` text
mitmproxy-termux/
├── install-mitmproxy.sh
└── README.md
```

## Security

Use mitmproxy only for systems and traffic that you own or have explicit
authorization to test, such as your own applications, lab environments,
and CTF targets.

Keep your mitmproxy CA private. Do not distribute the CA private key.

## License

This installer script is provided as-is for educational and authorized
security-testing use.
