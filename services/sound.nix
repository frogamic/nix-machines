{ config, pkgs, ... } : {
	sound.enable = true;
	hardware.pulseaudio.enable = true;
	# Explicit PulseAudio support in nixpkgs applications
	nixpkgs.config.pulseaudio = true;
}
