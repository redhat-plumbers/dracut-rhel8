#!/bin/bash

# called by dracut
check() {
    local _arch=$(uname -m)
    [ "$_arch" = "s390" -o "$_arch" = "s390x" ] || return 1
    require_binaries normalize_dasd_arg || return 1
    return 0
}

# called by dracut
depends() {
    echo "dasd_mod"
    return 0
}

# called by dracut
install() {
    inst_hook cmdline 30 "$moddir/parse-dasd.sh"
    inst_multiple dasdinfo dasdconf.sh normalize_dasd_arg
    conf=/etc/dasd.conf
    if [[ $hostonly && -f $conf ]] ; then
        inst -H $conf
    fi
    inst_rules 56-dasd.rules
    inst_rules 59-dasd.rules
}

