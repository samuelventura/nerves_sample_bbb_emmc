TYPE="${1:-sd}"

case $TYPE in
    sd)
    export MIX_ENV=dev
    export MIX_TARGET=bbb
    ;;
    emmc)
    export MIX_ENV=prod
    export MIX_TARGET=bbb_emmc
    ;;
esac

cd app_ui
mix deps.get --only $MIX_ENV 
mix compile
mix assets.deploy

cd ../app_fw
#first time requires 
#mix archive.install hex nerves_bootstrap
mix deps.get --only $MIX_ENV 
mix firmware

case $TYPE in
    sd)
    sudo fwup -aU -i _build/bbb_dev/nerves/images/app_fw.fw -t complete
    sync
    ;;
    emmc)
(cd _build/bbb_emmc_prod/nerves/images/ && sftp nerves.local) << EOF
put app_fw.fw /tmp/
quit
EOF

ssh nerves.local << EOF
cmd "fwup -aU -i /tmp/app_fw.fw -d /dev/mmcblk1 -t complete"
cmd "poweroff"
exit
EOF
    ;;
esac
