# idlebox

**idlebox** is a minimal Bedrock Linux stratum built entirely around BusyBox.

## What is idlebox?

idlebox is a **very minimal Bedrock Linux stratum** that provides just BusyBox — nothing else. It’s ideal for recovery, or if you like the most minimalistic init system ever.

## How can I use idlebox?

1. **Download the installer script**  
   Grab [`idleboxinstall.sh`](https://github.com/TheOddCell/idlebox/blob/main/idleboxinstall.sh)

2. **Build BusyBox yourself (recommended)**  
   Use a version of BusyBox that’s:
   - Compiled with `--static`
   - Built using glibc or any **non-musl** libc
   - Includes **all applets**, especially `init` and `login`

   Example build steps:
   ```
   make defconfig
   sed -i 's/^# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
   sed -i 's/^# CONFIG_INIT is not set/CONFIG_INIT=y/' .config
   sed -i 's/^# \(CONFIG_[A-Z0-9_]*\) is not set/\1=y/' .config
   make -j$(nproc)
   ```

3. **Too lazy to build it yourself?** (like me?)
   You can download prebuilt binaries from:

   https://busybox.net/downloads/binaries/

   - These are **musl-based**, so `login` may fail with modern password hashes
   - Either:
     - Switch `/bedrock/strata/[name]/etc/inittab` line 2 from `/bin/login` to `/bin/sh` (insecure, just gives you root)
     - Or use **SHA-512** (`$6$`) hashes in `/etc/shadow` (see below)

4. **Install the stratum**  
   Run the script as root:
   ```
   sh idleboxinstall.sh /path/to/busybox [optional-stratum-name]
   ```
   If no name is given, it defaults to `idlebox`.

5. **Done!**  
   You now have a tiny, BusyBox-only* stratum.

## Password Compatibility Notice

Modern Linux distros now use `yescrypt` for password hashing by default — but:

- **BusyBox does not support `yescrypt`**
- **musl builds make this worse** by lacking `crypt()` support for anything modern

If using `login`, make sure your password hash is:

- `$1$...` → **MD5**
- `$5$...` → **SHA-256**
- `$6$...` → **SHA-512 (recommended)**

To generate a SHA-512 password hash from a glibc system:
```
python3 -c 'import crypt; print(crypt.crypt("Password123!", crypt.mksalt(crypt.METHOD_SHA512)))'
```

Put the output into `/etc/shadow`. **

## How can I uninstall idlebox?

Just like any other stratum:
```
sudo brl remove -d idlebox
```

## Notes

- BusyBox's `init` is basic — don’t expect full service management
- Not production-ready — use this for lightweight experiments, containers, or as a rescue stratum

*There's a reason my favorite quote is "asterisk asterisk asterisk asterisk asterisk" from... I forgot. We have a few more config files then just busybox. But you get my point.
**Please don't use this password. I beg you.
