{
	inputs = {
		flake-utils.url = "github:numtide/flake-utils";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
		nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
		darwin = {
			url = "github:lnl7/nix-darwin/master";
			inputs.nixpkgs.follows = "nixpkgs-darwin";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v0.3.0";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.flake-utils.follows = "flake-utils";
		};
	};

	outputs = { self, nixpkgs, ... } @ inputs: let
		machineFolder = ./machines;
	in {
		nixosModules.default = {
			imports = import ./modules;
			nixpkgs.overlays = [
				self.overlays.default
			];
			nix = {
				nixPath = [ "nixpkgs=${nixpkgs}" ];
				registry = {
					master.to = {
						type = "github";
						owner = "NixOS";
						repo = "nixpkgs";
						ref = "master";
					};
					stable.flake = inputs.nixpkgs-stable;
					nixpkgs.flake = nixpkgs;
					n.flake = nixpkgs;
				};
			};
			system.configurationRevision = self.rev or self.dirtyRev or (builtins.trace ''
#######################################################
WARNING: system.configurationRevision could not be set!
#######################################################
			'' null);
		};

		overlays.default = final: prev: {
			stable = inputs.nixpkgs-stable.legacyPackages."${prev.system}";
			mylib = import ./mylib prev;
			mypkgs = self.packages."${prev.system}";
		};

		lib = import ./lib;

		nixosConfigurations = nixpkgs.lib.genAttrs
			(self.lib.getMachines machineFolder "linux")
			(name:
				let
					config = (import (machineFolder + "/${name}"));
				in
				nixpkgs.lib.nixosSystem (config // {
					modules = config.modules ++ [
						inputs.lanzaboote.nixosModules.lanzaboote
						self.nixosModules.default
					];
				})
			);

		darwinConfigurations = nixpkgs.lib.genAttrs
			(self.lib.getMachines machineFolder "darwin")
			(name:
				let
					config = (import (machineFolder + "/${name}"));
				in
				inputs.darwin.lib.darwinSystem config // {
					inputs = {
						inherit (inputs) darwin;
						nixpkgs = inputs.nixpkgs-darwin;
					};
				}
			);

	} // (inputs.flake-utils.lib.eachSystem inputs.flake-utils.lib.defaultSystems (system: {
		packages = import ./pkgs nixpkgs.legacyPackages.${system};
	}));
}
