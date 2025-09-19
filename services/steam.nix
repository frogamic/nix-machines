{ pkgs, ... } : {
	nixpkgs.config.allowUnfree = true;
	environment.systemPackages = [ pkgs.steamcmd ];
	programs.steam = {
		enable = true;
		localNetworkGameTransfers.openFirewall = true;
		remotePlay.openFirewall = true;
	};
	hardware.steam-hardware.enable = true;

	impermanence.persistence.user.directories = [
		".steam"
		".local/share/vulkan"
		".local/share/Steam"
		".cache/mesa_shader_cache"
	];
}
