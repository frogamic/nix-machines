with builtins;

let
	lib = (import ./.lib.nix);
in

listToAttrs (
	map
		(file: {
			name = lib.removeSuffix ".nix" (baseNameOf file);
			value = import file;
		})
		(import ./nixImportable.nix ./.)
)
