{
	outputs = { self, nixpkgs }: {
		nixosConfigurations = {
			enki = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./machines/enki.nix ];
			};
			ninhursag = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [ ./machines/ninhursag.nix ];
			};
		};
	};
}
