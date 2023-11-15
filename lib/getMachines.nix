folder:
with builtins;

let
	inherit (import ./.lib.nix) filterAttrs;
in
attrNames (filterAttrs
	(filename: entryType: entryType == "directory")
	(builtins.readDir folder)
)
