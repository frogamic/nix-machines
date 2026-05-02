{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.11";
		nixpkgs-master.url = "github:NixOS/nixpkgs/master";
		nixpkgs-frogamic.url = "github:frogamic/nixpkgs/main";
		flake-utils.url = "github:numtide/flake-utils";
		darwin = {
			url = "github:lnl7/nix-darwin/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		lanzaboote = {
			url = "github:nix-community/lanzaboote/v1.0.0";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		disko = {
			url = "github:nix-community/disko/v1.13.0";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		impermanence.url = "github:nix-community/impermanence";
		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		dotfiles = {
			url = "github:frogamic/dotfiles";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, ... } @ inputs: let
		machineFolder = ./machines;
	in {
		nixosModules = {
			default = {
				imports = with self.nixosModules; [
					withImports
					withInputs
					noImports
				];
			};
			withInputs = {
				imports = with inputs; [
					lanzaboote.nixosModules.lanzaboote
					disko.nixosModules.disko
					impermanence.nixosModules.impermanence
					nix-index-database.nixosModules.nix-index
					dotfiles.nixosModules.default
				];
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
				system.configurationRevision = toString (
					self.shortRev or self.dirtyShortRev or self.lastModified or "unknown"
				);
			};
		};

		overlays.default = final: prev: {
			stable = inputs.nixpkgs-stable.legacyPackages."${prev.stdenv.hostPlatform.system}";
			master = inputs.nixpkgs-master.legacyPackages."${prev.stdenv.hostPlatform.system}";
			frogamic = inputs.nixpkgs-frogamic.legacyPackages."${prev.stdenv.hostPlatform.system}";
			mylib = import ./mylib prev;
			mypkgs = self.packages."${prev.stdenv.hostPlatform.system}";
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
					modules = config.modules ++ [
						inputs.nix-index-database.darwinModules.nix-index
						self.nixosModules.noImports
					];
				})
			);

	} // (inputs.flake-utils.lib.eachSystem inputs.flake-utils.lib.defaultSystems (system: {
		packages = import ./pkgs nixpkgs.legacyPackages.${system};
	}));
}
