rec {
	pkgs = import ./pkgs;
	lib = import ./lib;
	overlay = final: prev: {
		mylib = lib prev;
		mypkgs = pkgs prev;
	};
	nixosModule = { pkgs, ... }: {
		nixpkgs.overlays = [
			overlay
		];
		imports = import ./src/nixImportable.nix ./modules;
	};
}
