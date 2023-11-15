nixpkgs: folder: extra:

with builtins;

let
	inherit (import ../lib/.lib.nix) removeSuffix;
	callPackage = path: {
		name = removeSuffix ".nix" (baseNameOf path);
		value = nixpkgs.callPackage path extra;
	};
in

listToAttrs (map callPackage (import ../lib/nixImportable.nix folder))
