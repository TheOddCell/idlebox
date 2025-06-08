# idlebox

**idlebox** is a minimal [Bedrock Linux](https://bedrocklinux.org/) stratum built entirely around BusyBox.

## What is idlebox?

idlebox is a **very minimal Bedrock Linux stratum** that provides just BusyBox — nothing else.  
It’s ideal for:

- Recovery and rescue
- Micro-container environments
- Fans of the most minimalistic init system possible


## How can I use idlebox?

### 1. Download the brl fetch script

Download the latest version here:  [`idlebox`](https://github.com/TheOddCell/idlebox/releases/download/v2.0.0/idlebox)


### 2. Install the stratum

Place the downloaded file into `/bedrock/share/brl-fetch/distros/` and type in the command `brl fetch idlebox` as `root`. You may use the same paramaters for `brl fetch`, found at `brl fetch --help`


### 3. Done

You now have a minimal BusyBox-only\* stratum.

## Extras

### Extra 1. DIY login (very recommended)

Create an user account with no password that has in the bashrc (or zshrc or etc):
```
su [user]
```

### Extra 2. Password setup (not recommended)

BusyBox does **not** support modern password hashes like `yescrypt`.

To ensure `login` works without a user dedicated to `su`, set a password **from inside the stratum**:

```
sudo strat [stratum-name] passwd [username]
```

This generates a DES-based password hash. For security, use this only for an account dedicated to idlebox, and restrict access from outside (e.g., block SSH, VNC, RDP) so it's only usable within idlebox.

SHA-256 and SHA-512 may work, but have not been tested. For better hash support, compile BusyBox yourself with:

- All applets enabled
- Static linking
- **glibc**, not musl

However, the best method is step 4a.

### Extra 3. Use your own `busybox` binary (may not work well)

After installing idlebox, disable idlebox with the command `brl disable [name]` as root,
as root copy your busybox binary to `/bedrock/strata/[name]/sbin/busybox`, then renable the strata as root with `brl enable [name]`

## How can I uninstall idlebox?

Like any Bedrock stratum:

```
sudo brl remove -d idlebox
```


## Notes

- BusyBox's `init` is very limited — no service manager, no PID 1 lifecycle management, unless you want to make it yourself
- idlebox is not production-ready — it's best suited for experiments, containers, or recovery environments

\*We’ve got a few config files too. But you get my point.
