# nerves_sample_bbb_emmc

## Install Development Tools

```bash
#https://elixir-lang.org/install.html#gnulinux for ubuntu/debian based on erlang-solutions release
apt install esl-erlang #1:24.1.3-1 amd64
#https://github.com/taylor/kiex
kiex install 1.12.3
kiex default 1.12.3
#https://github.com/nvm-sh/nvm
nvm install 16

samuel@p3420:~$ erl --version
Erlang/OTP 24 [erts-12.1.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]
Eshell V12.1.3  (abort with ^G)

samuel@p3420:~$ elixir --version
Erlang/OTP 24 [erts-12.1.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit]
Elixir 1.12.3 (compiled with Erlang/OTP 24)

samuel@p3420:~$ node --version
v16.13.0
```

## Nerves Installation

- https://hexdocs.pm/nerves/installation.html

## Create Projects in Pocho Layout

```bash
#Do not run these. Left here for reference.
#mix archive.install hex phx_new
#mix phx.new app_ui --no-ecto --no-mailer
#mix archive.install hex nerves_bootstrap
#mix nerves.new app_fw
```

## Build Dev SD Image

```bash
./build.sh dev bbb
sudo fwup -aU -i app_fw/_build/bbb_dev/nerves/images/app_fw.fw -d /dev/sdd -t complete
sync
#boot from this SD image by pressing S2
#ensure usb network is available
#check it is running from SD by looking a mount output
#expected /dev/mmcblk0p1 on /mnt/boot
ssh nerves.local << EOF
cmd "mount"
exit
EOF
#check ui is working http://nerves.local/
```

## Build Prod eMMC Image

```bash
./build.sh prod bbb_emmc
#ensure usb network is available
#transfer
(cd app_fw/_build/bbb_emmc_prod/nerves/images/ && sftp nerves.local) << EOF
put app_fw.fw /tmp/
quit
EOF
#flash
ssh nerves.local << EOF
cmd "fwup -aU -i /tmp/app_fw.fw -d /dev/mmcblk1 -t complete"
cmd "poweroff"
EOF
#boot from eMMC image by removing the SD.
#check it is running from eMMC by looking a mount output
#expected /dev/mmcblk1p1 on /mnt/boot
ssh nerves.local << EOF
cmd "mount"
exit
EOF
#check ui is working http://nerves.local/
```

First boots complains about:

- /root/.cache/erlang-history/erlang-shell-log.siz. Reason: enoent
- Disabling shell history logging.
- [   37.648982] Out of memory: Killed process 78 (beam.smp) total-vm:716488kB, anon-rss:496328kB, file-rss:28kB, shmem-rss:0kB, UID:0 pgtables:542kB oom_score_adj:0
- [   37.988259] watchdog: watchdog0: watchdog did not stop!

My guess is that the /root partition is being commissioned during that first boot. 

Just reboot with:

```bash
ssh nerves.local << EOF
cmd "reboot"
EOF
```

## Other Helpers

```bash
Application.started_applications
Application.get_all_env :app_ui
```
