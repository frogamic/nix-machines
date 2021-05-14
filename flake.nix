{
  outputs = { self, nixpkgs }: {
     nixosConfigurations = {
       enki = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [ ./machines/enki/configuration.nix ];
       };
       ninhursag = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [ ./machines/ninhursag/configuration.nix ];
       };
     };
  };
}
