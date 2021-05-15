{
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-20.09";
	};
	outputs = { self, nixpkgs, nixpkgs-stable } : let
		overlays = system: { pkgs, ... } : {
			nixpkgs.overlays = [
				(final : prev : {
					stable = nixpkgs-stable.legacyPackages."${system}";
					GodFuckingDamnitInputrcIsPartOfLibreadlineNotBash = {
						inputrc = builtins.readFile "${nixpkgs}/nixos/modules/programs/bash/inputrc";
					};
				})
			];
		};
	in {
		nixosConfigurations = with nixpkgs; builtins.listToAttrs (
			lib.flatten (
				map (
					machine: [
						{
							name = machine;
							value = lib.nixosSystem (
								import (./machines + "/${machine}.nix") overlays
							);
						}
					]
				)
				(map (lib.removeSuffix ".nix") (
					lib.attrNames (
						lib.filterAttrs
						(filename: entryType: entryType == "regular" && lib.hasSuffix ".nix" filename)
						(builtins.readDir ./machines)
					)
				)
			))
		);
	};
}
