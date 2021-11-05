# dev|prod
export MIX_ENV="${1:-dev}"
# bbb|bbb_emmc
export MIX_TARGET="${2:-bbb}"

cd app_ui
mix deps.get --only $MIX_ENV 
mix compile
mix assets.deploy

cd ../app_fw
mix deps.get --only $MIX_ENV 
mix firmware
