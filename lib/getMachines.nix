folder: system:

let
	inherit (builtins) attrNames filter readDir;
	inherit (import ./.lib.nix) filterAttrs hasSuffix removeSuffix;
	nixImportable = import ./nixImportable.nix;
in

map
	(f: removeSuffix ".nix" (baseNameOf f))
	(filter
		(f: hasSuffix system (import f).system)
		(nixImportable folder)
	)
