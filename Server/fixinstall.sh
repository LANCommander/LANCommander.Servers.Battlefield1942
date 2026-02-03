#! /bin/sh

# fixinstall.sh
# Lower-cases an entire directory tree from the current directory and downwards.
# Tested with bash and GNU findutils.
# Tested with FreeBSD's default sh and the standard toolchain.
#
# Usage:
#  $ cd /path/to/target/directory
#  $ fixinstall.sh
#
# Options:
#   --dry-run, --pretend, -p  -- only display what would be done
#   --verbose, -v             -- display what's going on while processing
#
# Author: Andreas Fredriksson
# Copyright: (c) 2003 Digital Illusions CE AB

# Parse some options in a semi-hackish way. Will probably break
# on non-GNU grep implementations.
(echo "$@" | grep -q -- '--dry-run\>\|--pretend\>\|-p\>') && DRYRUN=1
(echo "$@" | grep -q -- '--verbose\>\|-v\>') && VERBOSE=1

# no point in dry-run without verbose
test $DRYRUN && VERBOSE=1

test $VERBOSE && echo "case-converting directories.."
find . -type d | sort | while read DIR; do
	BASENAME=`echo $DIR | sed 's,/[^/]*$,,' | tr A-Z a-z`
	DIRNAME=`echo $DIR | sed 's,^.*/\([^/]*\)$,\1,'`
	DIRNAME_LC=`echo $DIRNAME | tr A-Z a-z`
	#test $VERBOSE && echo "$DIR base=$BASENAME dirname=$DIRNAME"
	if [ "x$DIRNAME" != "x$DIRNAME_LC" ]; then
		test $VERBOSE && echo "rename $DIRNAME to $DIRNAME_LC at ($BASENAME)";
		test -z $DRYRUN && mv "$BASENAME/$DIRNAME" "$BASENAME/$DIRNAME_LC"
	fi
done

test $VERBOSE && echo "case-converting files.."
find . -not -type d | grep '[A-Z]' | while read FILE; do
	FILE_LC=`echo $FILE | tr A-Z a-z`
	if [ "x$FILE" != "x$FILE_LC" ]; then
		test $VERBOSE && echo "rename $FILE to $FILE_LC"
		test -z $DRYRUN && mv "$FILE" "$FILE_LC"
	fi
done

