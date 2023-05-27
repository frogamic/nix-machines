{ config, pkgs, ... } : {
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};
	nixpkgs.config.pipewire = true;
	environment.systemPackages = [
		pkgs.wireplumber
	];
}
