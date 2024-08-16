#!/bin/sh

SHARE_DIR='/etc/samba/shares.d'
SHARE_TGT='/etc/samba/_generated-shares.conf'
SHARE_DEFAULT='/etc/samba/default-share.conf'

if [ ! -e "$SHARE_TGT" ]; then
	mkdir "$SHARE_DIR"
	if [ -z "${NO_DEFAULT_SHARE:+1}" ]; then
		[ -e "${SHARE_DIR}/default.conf" ] \
			|| ln -s "$SHARE_DEFAULT" "${SHARE_DIR}/default.conf"
	fi
	find -H "$SHARE_DIR" \
		-mindepth 1 \
		-maxdepth 1 \
		'(' -type f -o -type l ')' \
		-name '*.conf' \
		-exec printf 'include = %s\n' {} + \
		> "$SHARE_TGT"
fi

[ "$1" = "smbd" ] && shift
if [ $# -eq 0 ] || [ "${1#-}" != "${1}" ]; then
	set -- tini -- smbd --foreground --no-process-group "$@"
fi

exec "$@"
