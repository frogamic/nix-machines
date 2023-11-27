nixpkgs: folder: extra:

let
	inherit (builtins) baseNameOf listToAttrs;
	inherit (import ../lib/.lib.nix) removeSuffix;

	callPackage = path: {
		name = removeSuffix ".nix" (baseNameOf path);
		value = nixpkgs.callPackage path extra;
	};
in

listToAttrs (map callPackage (import ../lib/getImportable.nix folder))
