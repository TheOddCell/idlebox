#!/bedrock/libexec/busybox sh
# idlebox
# bootstrap a minimal stratum with just busybox
# This is free and unencumbered software released into the public domain.
# See the file LICENSE for more information.

set -e

show_help() {
    echo "idlebox - Bootstrap a stratum that just contains busybox"
    echo "Usage: $0 [path to busybox] [name]"
    echo "Don't use Bedrock's builtin busybox, use official prebuilts from https://busybox.net/downloads/binaries/"
    exit 1
}

if [ $# -lt 1 ]; then
    show_help
fi

if [ ! -d /bedrock ]; then
    echo "This script must be run on a Bedrock Linux system (missing /bedrock/)"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "Must be run as root."
    exit 1
fi

arg="$1"
name="$2"

if [ ! -f "$arg" ]; then
    echo "File does not exist: $arg"
    show_help
fi

boxpath="$(readlink -f "$arg")"

if [ -z "$name" ]; then
    name="idlebox"
fi

echo "Using BusyBox at: $boxpath"
echo "Stratum name: $name"

# Setup basic filesystem
echo "Setting up basic filesystem"
mkdir -p "/bedrock/strata/$name/sbin"

# Install busybox
echo "Installing busybox"
cp "$boxpath" "/bedrock/strata/$name/sbin/busybox"
chmod +x "/bedrock/strata/$name/sbin/busybox"

# Symlink all busybox applets
cd "/bedrock/strata/$name/sbin/"
echo "Symlinking all utilities"
for cmd in $(./busybox --list); do
    echo "Symlinking $cmd to busybox"
    ln -sf busybox "$cmd"
done

# Add bin symlink
echo "Symlinking /bin/ to /sbin/"
ln -s "/bedrock/strata/$name/sbin/" "/bedrock/strata/$name/bin"

# Enable stratum
echo "Showing and enabling $name"
brl show "$name"
brl enable "$name"

# Write inittab
echo "Writing inittab"
mkdir -p "/bedrock/strata/$name/etc/"
cat > "/bedrock/strata/$name/etc/inittab" <<'EOF'
::sysinit:/etc/init.d/rcS
::respawn:/bin/login
::ctrlaltdel:/bin/reboot
EOF

# Write rcS
echo "Writing rcS"
mkdir -p "/bedrock/strata/$name/etc/init.d/"
cat > "/bedrock/strata/$name/etc/init.d/rcS" <<'EOF'
#!/bin/sh
echo "[idlebox] rcS starting..."

mount -t proc proc /proc
mount -t sysfs sys /sys
mount -o remount,rw /

# Optional: start networking
ifconfig lo up
ifconfig eth0 up || true
udhcpc -i eth0 || true

echo "[idlebox] rcS complete."
EOF

chmod +x "/bedrock/strata/$name/etc/init.d/rcS"

echo "Done! Your strata should work!"
echo "The following text should be $name:"
brl which busybox
