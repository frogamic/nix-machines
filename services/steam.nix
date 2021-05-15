{ pkgs, ... } : {
	nixpkgs.config.allowUnfree = true;
	environment.systemPackages = [
		pkgs.steamPackages.steamcmd
	];
	programs.steam.enable = true;
	hardware.steam-hardware.enable = true;
}
