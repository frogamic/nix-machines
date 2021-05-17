{ config, pkgs, ... } : {
	sound.enable = true;
	hardware.pulseaudio.enable = true;
	nixpkgs.config.pulseaudio = true;
}
