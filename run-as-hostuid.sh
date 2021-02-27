#!/bin/sh
# Copyright (C) 2020 Wesley Tanaka
#
# This file is part of cliwrap
#
# cliwrap is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# cliwrap is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied warranty
# of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with cliwrap.  If not, see
# <http://www.gnu.org/licenses/>.

# From http://www.etalabs.net/sh_tricks.html
save () {
  for i do printf %s\\n "$i" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/' \\\\/" ; done
  echo " "
}
quote () {
  printf %s\\n "$1" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'/" ;
}

usercommand=$(save "$@")

HOSTUSERNAME=hostuser
HOSTGROUPNAME=hostgroup
HOSTHOMEDIR="/home/$HOSTUSERNAME"
if [ -z "$WORKDIR" ]; then
  WORKDIR=/work
fi

COMMAND="$usercommand"
if [ -d "$WORKDIR" ]; then
  COMMAND="; ${COMMAND}"
  COMMAND=$(quote "$WORKDIR")"$COMMAND"
  COMMAND="cd $COMMAND"
fi

if [ -n "$HOSTUID" ]; then
  # id -u doesn't work inside alpine3.7/busybox
  if cut -d: -f3 /etc/passwd | grep "^${HOSTUID}$" 2>&1 > /dev/null; then
    # User already exists
    OIFS="$IFS"
    IFS=":"
    while read LINE; do
      set -- $LINE
      if [ "$3" = "${HOSTUID}" ]; then
         HOSTUSERNAME="$1"
         export HOSTUSERNAME
      fi
    done < /etc/passwd
    IFS="$OIFS"
  else
    # User does not exist, need to add them
    CHOWNGROUP="$HOSTUSERNAME"
    CHOWNUSER="$HOSTUIDNAME"
    USERADDCMD=$(quote adduser)
    USERADDCMD="$USERADDCMD "$(quote '-D')
    USERADDCMD="$USERADDCMD "$(quote '-s')
    USERADDCMD="$USERADDCMD "$(quote '/bin/sh')
    USERADDCMD="$USERADDCMD "$(quote '-u')
    USERADDCMD="$USERADDCMD "$(quote "$HOSTUID")
    if [ -n "$HOSTGID" ]; then
      CHOWNGROUP="$HOSTGID"
      EXISTING_GROUP="$(getent group "$HOSTGID" | cut -d: -f1)"
      if [ -n "$EXISTING_GROUP" ]; then
        HOSTGROUPNAME="$EXISTING_GROUP"
      else
        addgroup -g "$HOSTGID" "$HOSTGROUPNAME"
      fi
      USERADDCMD="$USERADDCMD "$(quote '-G')
      USERADDCMD="$USERADDCMD "$(quote "$HOSTGROUPNAME")
    fi
    USERADDCMD="$USERADDCMD "$(quote "$HOSTUSERNAME")
    eval "$USERADDCMD"
    mkdir -p "$HOSTHOMEDIR"
    chown "$HOSTUSERNAME":"$HOSTGID" "$HOSTHOMEDIR"
  fi
  if command -v sudo 2>&1 > /dev/null; then
    # Enable passwordless sudo
    printf "%s ALL=(ALL) NOPASSWD:ALL" "$HOSTUSERNAME" > \
      /etc/sudoers.d/"$HOSTUSERNAME"
  fi
fi

if [ -n "$HOSTUID" ]; then
  exec su - "$HOSTUSERNAME" -c "$COMMAND"
else
  eval "$COMMAND"
fi
