nixpkgs:

let
	nixImportable = import ../lib/nixImportable.nix;
	callAllPackages = import ./callAllPackages.nix nixpkgs;
in

callAllPackages ./. {}
