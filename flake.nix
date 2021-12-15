{
	inputs = {
		flake-utils.url = "github:numtide/flake-utils";
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-21.05";
	};
	outputs = { self, ... } @ inputs:
		let
			mkOverlays = system: {
				nixpkgs.overlays = [
					(final: prev: {
						stable = inputs.nixpkgs-stable.legacyPackages."${system}";
					})
				];
			};
			mkNixosSystem = machineConfig: inputs.nixpkgs.lib.nixosSystem (
				machineConfig // {
					modules = machineConfig.modules ++ [
						self.nixosModule
						{
							system.configurationRevision = inputs.nixpkgs.lib.mkIf (self ? rev) self.rev;
							nix = {
								nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
								registry.nixpkgs.flake = inputs.nixpkgs;
							};
						}
						(mkOverlays machineConfig.system)
					];
				}
			);
			mkMachine = folder: machine: {
				name = machine;
				value = mkNixosSystem (import (folder + "/${machine}.nix"));
			};
			getMachines = folder: with inputs.nixpkgs; (
				map (lib.removeSuffix ".nix") (
					lib.attrNames (
						lib.filterAttrs
						(filename: entryType: entryType == "regular" && lib.hasSuffix ".nix" filename)
						(builtins.readDir folder)
					)
				)
			);
			machineFolder = ./machines;
		in
		{
			inherit (import ./.) overlay nixosModule;
			nixosConfigurations = builtins.listToAttrs (
				map (mkMachine machineFolder) (getMachines machineFolder)
			);
		} // (inputs.flake-utils.lib.eachSystem inputs.flake-utils.lib.defaultSystems (
			system: {
				packages = (import ./.).pkgs inputs.nixpkgs.legacyPackages.${system};
			}
		));
}
