nixpkgs:
	let
		nixImportable = import ../src/nixImportable.nix;
		callAllPackages = import ../src/callAllPackages.nix nixpkgs;
	in
		(callAllPackages ./. {}) // {
			inherit nixImportable callAllPackages;
		}
