#! /bin/sh

# Tell non-linux users not to use start.sh.
# This is probably not the most elegant way of doing it.
MYSYS=`uname`

if [ x"$MYSYS" != x"Linux" ]; then
   cat << _EOM_
The start.sh shell script only works when running Linux. For help with running
the server on your platform ($MYSYS), please see the various threads at the
official beta forum: http://bf1942.lightcubed.com/forum .

For FreeBSD, follow these steps:
- Enable Linux binary compatibility
- Symbolically link from bf1942_lnxded.static to bf1942_lnxded
- Replace start.sh in the documentation with bf1942_lnxded
_EOM_
   exit 1;
fi

# remove old symbolic link
rm -f bf1942_lnxded

# use ldd to look for 'not found' errors
if ldd bf1942_lnxded.dynamic 2>&1 | grep -q -i not\ found; then
   echo "$0: using statically linked binary";
   ln -s bf1942_lnxded.static bf1942_lnxded;
else
   echo "$0: using dynamically linked binary";
   ln -s bf1942_lnxded.dynamic bf1942_lnxded;
fi

# launch binary
exec ./bf1942_lnxded $@
