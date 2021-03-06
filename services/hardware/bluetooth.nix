{ config, pkgs, lib, ... } : {
	hardware.bluetooth = {
		enable = true;
		package = pkgs.bluezFull;
	};
	hardware.pulseaudio = lib.mkIf config.hardware.pulseaudio.enable {
		package = pkgs.pulseaudioFull;
		extraModules = [ pkgs.pulseaudio-modules-bt ];
	};
}
