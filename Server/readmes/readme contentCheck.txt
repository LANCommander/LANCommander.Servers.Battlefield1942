
------------------------------------------------------------------------------
Battlefield 1942 version 1.4: CRC content check
------------------------------------------------------------------------------

Background
------------------------------------------------------------------------------

DICE has rewritten the CRC checking system to let server administrators decide
if they want to allow client side modifications on their servers.  The system
is based on the game.serverContentCheck server setting and a number of
contentCrc32.con files. 

The serverContentCheck variable can now take on three values:

  0 - All clients are allowed.
  1 - Only clients with default installations are allowed.
  2 - Only clients with installations matching any of the server-defined CRCs
      are allowed.

The conentCrc32.con files are parsed by the server to load a set of CRCs that
will be considered as valid. As clients connect they will be checked against
these values. The CRC files reside in the directory of each mod.

Generating CRC data for mods
------------------------------------------------------------------------------

If you decide to allow a certain client side mod, or if you need to generate
CRC checksums for a client/server mod follow these steps:

 1) Use a client installation of the mod you are working on.

 2) Run the following command from the bf1942 install directory:

    bf1942.exe +generateMapListForCrcContent 1

	This will instruct the game to write out a batch file called
	"mapListForCrcContent.bat".
	
 3) The batch file contains commands to generate CRCs for all maps of all mods
    which probably isn't what you want. Therefore, edit the batch file with a text
    editor to include only the maps you need.

 4) Run the batch file from the bf1942 install directory:

    mapListForCrcContent.bat

	The game will start and stop once for every map in the batch file. As
	levels are loaded, their calculated CRC checksums will be written to the
	contentCrc32.con file of the current mod. If you need to run this serveral
	times please note that values are appended, not replaced. Therefore it can
	be useful to keep a backup copy of the original contentCrc32.con file to be
	restored before generation.

 5) Copy the resulting contentCrc32.con files to the server.

Making mod data compatible with the CRC system
------------------------------------------------------------------------------

For the CRC system to work, the game data must live up to a set of rules that
affect how the calculations are performed on client and server:

- The object spawns must be present on both client and server.

- The same con files must be sourced on client and server.

- Most menu and HUD textures cannot have mipmaps.

Without these changes clients will receive DATA DIFFERS errors when connecting
to a server running the mod.

