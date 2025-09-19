{ pkgs, ... } : {
	nixpkgs.config.allowUnfree = true;
	environment.systemPackages = [ pkgs.steamcmd ];
	programs.steam.enable = true;
	hardware.steam-hardware.enable = true;

	impermanence.persistence.user.directories = [
		".steam"
		".local/share/vulkan"
		".local/share/Steam"
	];
}
