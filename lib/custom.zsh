export OSX_SUPERB="$ZSH_CUSTOM/plugins/osx-superb"
export SUPERB_ALIAS="$ZSH_CUSTOM/plugins/superb-aliases"

function upgrade_oh_my_zsh_custom() {
  env ZSH_CUSTOM=$ZSH_CUSTOM /bin/sh $ZSH_CUSTOM/tools/upgrade.sh
}
