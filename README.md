# idlebox

**idlebox** is a minimal [Bedrock Linux](https://bedrocklinux.org/) stratum built entirely around BusyBox.

---

## What is idlebox?

idlebox is a **very minimal Bedrock Linux stratum** that provides just BusyBox — nothing else.  
It’s ideal for:

- Recovery and rescue
- Micro-container environments
- Fans of the most minimalistic init system possible

---

## How can I use idlebox?

### 1. Download the installer script

Download the latest version here:  
[`idleboxinstall.sh`](https://github.com/TheOddCell/idlebox/releases/download/v1.1.0/idleboxinstall.sh)

---

### 2. Download a BusyBox binary

Prebuilt binaries are available at:  
https://busybox.net/downloads/binaries/

> These are musl-based. `login` may not work with modern password hashes (see step 5).

---

### 3. Install the stratum

Run the script as root:

```sh
sh idleboxinstall.sh /path/to/busybox [optional-stratum-name]
```

If no name is given, the stratum defaults to `idlebox`.

---

### 4. Done

You now have a minimal BusyBox-only\* stratum.

---

### 5. Password setup (optional but recommended)

BusyBox does **not** support modern password hashes like `yescrypt`.

To ensure `login` works, set a password **from inside the stratum**:

```sh
sudo strat [stratum-name] passwd [username]
```

This generates a DES-based password hash. For security, use this only for an account dedicated to idlebox, and restrict access from outside (e.g., block SSH, VNC, RDP) so it's only usable within idlebox.

SHA-256 and SHA-512 may work, but have not been tested. For better hash support, compile BusyBox yourself with:

- All applets enabled
- Static linking
- **glibc**, not musl

---

## How can I uninstall idlebox?

Like any Bedrock stratum:

```sh
sudo brl remove -d idlebox
```

---

## Notes

- BusyBox's `init` is very limited — no service manager, no PID 1 lifecycle management, unless you want to make it yourself
- idlebox is not production-ready — it's best suited for experiments, containers, or recovery environments

\*We’ve got a few config files too. But you get my point.
