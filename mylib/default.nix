nixpkgs:

let
	lib = import ../lib;
in

lib // lib.callAllPackages nixpkgs ./. {}
