#! /bin/sh
#
# Copyright 2018 Gavin D. Howard
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#

usage() {
	printf "usage: %s install_dir main_exec\n" "$0" 1>&2
	exit 1
}

script="$0"
scriptdir=$(dirname "$script")

. "$scriptdir/tests/functions.sh"

INSTALL="$scriptdir/safe-install.sh"

test "$#" -ge 2 || usage

install_dir="$1"
shift

main_exec="$1"
shift

catalog_dir="$scriptdir/locales/catalogs"

for file in $catalog_dir/*.cat; do

	base=$(basename "$file")
	name=$(removeext "$base")
	d="$install_dir/$name/LC_MESSAGES"
	loc="$install_dir/$name/LC_MESSAGES/$main_exec.cat"

	mkdir -p "$d"

	if [ -L "$file" ]; then
		link=$(readlink "$file")
		linkname=$(basename "$link")
		"$INSTALL" -Dlm 755 "../../$linkname/LC_MESSAGES/$link" "$loc"
	else
		"$INSTALL" -Dm 755 "$file" "$loc"
	fi

done
