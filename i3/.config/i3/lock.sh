#!/bin/sh
lock() {
    i3lock-fancy -g
}

# xsecurelock
xlock() {
	export XSECURELOCK_DISCARD_FIRST_KEYPRESS=0
	export XSECURELOCK_PASSWORD_PROMPT=time_hex
	export XSECURELOCK_SHOW_DATETIME=1
	export XSECURELOCK_SHOW_KEYBOARD_LAYOUT=0
	export XSECURELOCK_SHOW_HOSTNAME=0
	xsecurelock
}


case "$1" in
    lock)
        xlock
        ;;
    logout)
        i3-msg exit
        ;;
    suspend)
        lock && systemctl suspend
        ;;
    hibernate)
        lock && systemctl hibernate
        ;;
    reboot)
        systemctl reboot
        ;;
    shutdown)
        systemctl poweroff
        ;;
    *)
        echo "Usage: $0 {lock|logout|suspend|hibernate|reboot|shutdown}"
        exit 2
esac

exit 0
