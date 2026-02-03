#! /bin/sh

# Quick install script to show the EA and PB EULAs and then install
# the software. Run from the makeself script.

echo
echo "You will now be shown the EULA for the BF1942 dedicated Linux server."
echo "Press return to continue."
read DUMMY

more readmes/eula.txt

STATUS=""
while [ -z "$STATUS" ]; do
	echo -n "Please type 'accept' or 'decline': "
	read INPUT
	if [ "x$INPUT" = 'xdecline' ]; then STATUS='decline'; fi
	if [ "x$INPUT" = 'xaccept' ]; then STATUS='accept'; fi
done

if [ "$STATUS" = 'decline' ]; then
	echo "Aborting installation.";
	exit 1;
fi

echo
echo "You will now be shown the EULA for PunkBuster. Press return to continue."
read DUMMY
echo; echo

more readmes/pb_eula.txt

echo; echo
echo "Would you like to install the PunkBuster software now?"

PB=""
while [ -z "$PB" ]; do
	echo -n "Please type 'yes' or 'no': "
	read INPUT
	if [ "x$INPUT" = 'xyes' ]; then PB='yes'; fi
	if [ "x$INPUT" = 'xno' ]; then PB='no'; fi
done

echo; echo
echo "The target installation directory is where the bf1942 directory will be created";
echo "and must be an existing directory.";

TARGET=""
while [ -z "$TARGET" ]; do
	echo -n "Enter your target installation directory: ";
	read INPUT;
	TARGET="$INPUT"; 
done

if test -a "$TARGET/bf1942"; then
	echo
	echo -n "The directory $TARGET/bf1942 will be removed; are you sure (y/n)?";
	read INPUT
	if [ "x$INPUT" != 'xy' ]; then
		echo "Aborting.";
		exit 1;
	fi
fi

rm -rf "$TARGET"/bf1942
if [ "x$OSTYPE" = "xlinux-gnu" ]; then
	mkdir -p "$TARGET"/bf1942 || exit 1;
else
	mkdir "$TARGET"/bf1942 || exit 1;
fi
	

cp -r \
	bf1942_lnxded.dynamic bf1942_lnxded.static start.sh \
	bfpridaemon mods readmes fixinstall.sh \
	"$TARGET/bf1942"

if [ "$PB" = 'yes' ]; then
	cp -r pb "$TARGET/bf1942";
fi

echo
echo "Installation complete."
