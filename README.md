# idlebox
busybox provides init? brb creating a stratum
## What is idlebox?
idlebox is a system for creating an (very minimal) stratum that just contiains busybox
## How can I use idlebox?
1. Download the installer script
2. Download the latest busybox binaries from https://busybox.net/downloads/binaries/. Don't use the bedrock builtin busybox, and if compiling yourself make sure to include all utils.
3. Run `sh idleboxinstall.sh [locaton of busybox binary] [optional: name of stratum, defaults to "idlebox"]` as `root`
4. Done!
## How can I uninstall idlebox?
Just like any other strata:

Run `brl remove -d [name]` as `root`.
