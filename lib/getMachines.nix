folder: system:
with builtins;

let
	inherit (import ./.lib.nix) filterAttrs removeSuffix hasSuffix;
	nixImportable = import ./nixImportable.nix;
in

map
	(f: removeSuffix ".nix" (baseNameOf f))
	(filter
		(f: hasSuffix system (import f).system)
		(nixImportable folder)
	)
