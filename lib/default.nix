
let
	inherit (builtins) baseNameOf listToAttrs;
	inherit (import ./.lib.nix) removeSuffix;
in

listToAttrs (
	map
		(file: {
			name = removeSuffix ".nix" (baseNameOf file);
			value = import file;
		})
		(import ./getImportable.nix ./.)
)
