{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.11";
		nixpkgs-master.url = "github:NixOS/nixpkgs/master";
		nixpkgs-frogamic.url = "github:frogamic/nixpkgs/main";
		flake-utils.url = "github:numtide/flake-utils";
		darwin = {
			url = "github:lnl7/nix-darwin/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v0.4.2";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko = {
			url = "github:nix-community/disko/v1.6.1";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		impermanence.url = "github:nix-community/impermanence";
	};

	outputs = { self, nixpkgs, ... } @ inputs: let
		machineFolder = ./machines;
	in {
		nixosModules = {
			default = {
				imports = with self.nixosModules; [ withImports noImports ];
			};
			withImports = {
				imports = import ./modules;
			};
			noImports = {
				nixpkgs.overlays = [
					self.overlays.default
				];
				nix = {
					nixPath = [ "nixpkgs=${nixpkgs}" ];
					registry = {
						master.flake = inputs.nixpkgs-master;
						stable.flake = inputs.nixpkgs-stable;
						nixpkgs.flake = nixpkgs;
						n.flake = nixpkgs;
					};
				};
				system.configurationRevision = self.rev or self.dirtyRev or (builtins.trace
					"WARNING: system.configurationRevision could not be set!"
					null
				);
			};
		};

		overlays.default = final: prev: {
			stable = inputs.nixpkgs-stable.legacyPackages."${prev.system}";
			master = inputs.nixpkgs-master.legacyPackages."${prev.system}";
			frogamic = inputs.nixpkgs-frogamic.legacyPackages."${prev.system}";
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
						inputs.disko.nixosModules.disko
						inputs.impermanence.nixosModules.impermanence
						self.nixosModules.default
						{ networking.hostName = self.lib.mkDefault name; }
					];
				})
			);

		darwinConfigurations = nixpkgs.lib.genAttrs
			(self.lib.getMachines machineFolder "darwin")
			(name:
				let
					config = (import (machineFolder + "/${name}"));
				in
				inputs.darwin.lib.darwinSystem (config // {
					inputs = {
						inherit (inputs) darwin nixpkgs;
					};
					modules = config.modules ++ [ self.nixosModules.noImports ];
				})
			);

	} // (inputs.flake-utils.lib.eachSystem inputs.flake-utils.lib.defaultSystems (system: {
		packages = import ./pkgs nixpkgs.legacyPackages.${system};
	}));
}
