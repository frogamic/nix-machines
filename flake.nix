{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
		myOverlay.url = "github:frogamic/nixpkgs-overlay";
	};
	outputs = { self, ... } @ inputs:
		let
			mkOverlays = system: {
				nixpkgs.overlays = [
					inputs.myOverlay.lib
					(final: prev: {
						stable = inputs.nixpkgs-stable.legacyPackages."${system}";
						GodFuckingDamnitInputrcIsPartOfLibreadlineNotBash = {
							inputrc = builtins.readFile "${inputs.nixpkgs}/nixos/modules/programs/bash/inputrc";
						};
					})
				];
			};
			mkNixosSystem = machineConfig: inputs.nixpkgs.lib.nixosSystem (
				machineConfig // {
					modules = machineConfig.modules ++ [
						{ system.configurationRevision = inputs.nixpkgs.lib.mkIf (self ? rev) self.rev; }
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
			nixosConfigurations = builtins.listToAttrs (
				map (mkMachine machineFolder) (getMachines machineFolder)
			);
		};
}
