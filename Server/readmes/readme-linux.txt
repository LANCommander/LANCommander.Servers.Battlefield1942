
------------------------------------------------------------------------------
Release notes: Battlefield 1942 free dedicated Linux server version 1.6
Battlefield 1942 is a registered trademark of Digital Illusions CE AB.
(c) 2000-2004 Digital Illusions CE AB
------------------------------------------------------------------------------

Quick start
==============================================================================

- Run the server installer and follow the instructions.

  IMPORTANT:
	Please note that if you choose to install the server over an existing
	installation the existing installation directory will be removed!

  Example:
  $ sh bf1942_lnxded-1.x.y.run

- Modify mods/bf1942/settings/serversettings.con to your taste.

  Example:
  $ cd /path/to/installation/bf1942
  $ vi mods/bf1942/settings/serversettings.con

- Modify mods/bf1942/settings/maplist.con to your taste.

  Example:
  $ cd /path/to/installation/bf1942
  $ vi mods/bf1942/settings/serversettings.con

  IMPORTANT:
    Please see the information below to understand the new map list format.

- Run the server from within the top-level directory by typing
  ./start.sh [arguments] from a shell.

  Example:
  $ cd /path/to/installation/bf1942
  $ ./start.sh +statusMonitor 1

- If you are starting the server from a remote connection you will need to
  encapsulate it inside a "screen" session to let it stay behind when you log
  out from the shell.

  Example (to start the server):
  $ cd /path/to/installation/bf1942
  $ screen ./start.sh +statusMonitor 1
  Now press Ctrl-A followed by Ctrl-D to detach the screen session, leaving it
  running in the background. You can now log out without affecting the server.

  Example (to reconnect to the server status monitor):
  $ screen -r

  Please see the man page for screen to learn more about what it can do.


More information
==============================================================================

Welcome to the Battlefield 1942 dedicated server. For patch-specific
information please refer to the generic read me file included with both the
Linux and win32 distributions.

For discussion with the developers and other users of this server please
subscribe to the bf1942 mailing list. To join the list, send a message to
<bf1942-subscribe@icculus.org> and follow the instructions given to you in the
reply.

If you prefer to use a forum, there is one set up at the distribution site for
the open beta series at http://www.bf1942.lightcubed.com . You can report bugs
both in the forum and on the mailing list. Please don't send bug reports in
private mail, use the forum or the list instead.

DICE would like to thank Ryan C. Gordon for his work on the earlier Linux
releases and the bf1942 Linux community for their test feedback, bug reports
and patience.


The file case confusion problem solved
==============================================================================

The 1.6 Linux server will read lower-case filenames ONLY. All file names
encountered at runtime are lower-cased before a filesystem access is
attempted. You should therefore make sure all files are lower-case when
installing third-party modifications and maps.

To aid you with this there is an included bourne shell script called
fixinstall.sh which recursively changes the case of files and directories from
the directory where it's run.

You can simulate the actions of the script with these options:
 $ ./fixinstall.sh --pretend

When you're certain it looks good run the conversion:
 $ ./fixinstall.sh --verbose


Map list and +game changes in the 1.6 server
==============================================================================

The maplist.con format has changed to allow any combination of mods and game
modes in the same map cycle. Please see the generic read me file for more
information about the format.

This change essentially renders the +game command-line option useless for
dedicated servers and hence it should not be used.


Banning by unique identifiers (CD key hashes)
==============================================================================

This release of the dedicated Linux server includes a system to ban players by
their unique CD key hash. The system is similar to the current IP-based
banning system but uses the following new console commands:

admin.banPlayerKey <player number>
admin.listBannedKeys
admin.addKeyToBanList <key>
admin.removeKeyFromBanList <key> 

Banned player keys are stored together with the IP-based bans in the
banlist.con file. IP-based bans continue to work if you would still like to
use them.

Please note that the PunkBuster system also has a CD key hash banning system
that works separately from the built-in system.

Known issues
==============================================================================

To work around bugs in some implementations of pthreads (the standard system
threading library on Linux) the server allows you to explicitly set the stack
size to use for new threads. If you need to change this limit you can do so
with the BF1942_STACKSIZE environment variable by exporting it to the server's
environment:

$ export BF1942_STACKSIZE=`expr 4 \* 1024 \* 1024`
$ ./start.sh +statusMonitor 1

This example sets the stack size to four megabytes.

You can also combine the two lines:
$ BF1942_STACKSIZE=`expr 4 \* 1024 \* 1024` ./start.sh +statusMonitor 1

If you see errors about thread creation you might need to use this option.

Option summary
==============================================================================

The following options are unique for the Linux server:

+statusMonitor	1 

Enables the curses status monitor which enables you to work with the in-game
console directly at the server.

+priorityDaemon 1

Enables sending priority change requests to the external root daemon
(bfpridaemon) which changes the server niceness while loading. Use this option
(and run the external daemon) to reduce the CPU stress when running multiple
servers on the same machine.

The priority daemon itself is distributed as source code and can be found
under the `bfpridaemon' subdirectory of the installation. Use of this code is
at your own risk and there is no warranty what so ever.

Please note that the following options are deprecated and do not effect the
server in any way: +restart, +dedicated and +game.

Have fun with your Linux server!

Andreas Fredriksson <andreas.fredriksson@dice.se>


Licensing information
==============================================================================

The Battlefield 1942 server is linked with the GNU C and C++ libraries which
are under the LGPL license. By linking dynamically we ensure that you as a
user can use this software with other versions of these libraries.

A statically linked binary also linked with these libraries is supplied purely
for convenience should you not be able to run the dynamically linked binary.

The LGPL license text is included with this release and can be found on the
web at http://www.gnu.org/licenses/lgpl.html.

Please note that the Battlefield 1942 dedicated server itself is not covered
by the LGPL license.


Revision history
==============================================================================
Filename: bf1942_lnxded-1.6-rc2.tar.bz2
MD5 sums: 5cb151f768f760888671a15667ba751d  bf1942_lnxded.dynamic
          fca65f65ef1b059fd7af8bb28b9ae7fb  bf1942_lnxded.static
Version: BF1942 (Ver: Mon, 02 Feb 2004 15:10:05/dep@mayall.internal.dice.se)
Release status: 1.6 Release Candidate 2

Changes in this release:
- Fixed installer script bash dependency
- Fixed a potentially dangerous bug with the GameSpy query interface
- Fixed stall bug with remote console connections (was causing lag)
- Fixed trashed mirrored remote console output

==============================================================================
Filename: bf1942_lnxded-1.6-rc1.tar.bz2
MD5 sums: 5aed9c067aad5c381b7125ed666f2375  bf1942_lnxded.dynamic
          6c6508aae7d61ab7198b78473efd4e18  bf1942_lnxded.static
Version: BF1942 (Ver: Mon, 26 Jan 2004 11:46:25/dep@mayall.internal.dice.se)
Release status: First 1.6 release candidate.

Changes: Please see the read me files.

