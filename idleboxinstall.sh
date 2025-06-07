#!/bedrock/libexec/busybox sh
# idlebox
# bootstrap a minimal stratum with just busybox
# This is free and unencumbered software released into the public domain.
# See the file LICENSE for more information.

set -e

if [ ! -d /bedrock ]; then
    echo "This script must be run on a Bedrock Linux system (missing /bedrock/)"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
  echo "Must be run as root."
  exit 1
fi

show_help() {
    echo "idlebox - Bootstrap a stratum that just contains busybox"
    echo "Usage: $0 [path to busybox] [name]"
    echo "Don't use Bedrock's builtin busybox, use official prebuilts from https://busybox.net/downloads/binaries/"
    exit 1
}

if [ $# -lt 1 ]; then
    show_help
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

mkdir -p "/bedrock/strata/$name/sbin"
cp "$boxpath" "/bedrock/strata/$name/sbin/busybox"
chmod +x "/bedrock/strata/$name/sbin/busybox"

cd "/bedrock/strata/$name/sbin/"
for cmd in $(./busybox --list); do
    ln -sf busybox "$cmd"
done

ln -s "/bedrock/strata/$name/sbin/" "/bedrock/strata/$name/bin"

brl show "$name"
brl enable "$name"

echo "Done! Your strata should work!"
echo "The following text should be $name:"
brl which busybox
