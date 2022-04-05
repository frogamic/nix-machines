{ config, pkgs, ... } : {
	# sound.enable = true;
	# hardware.pulseaudio.enable = true;
	# Explicit PulseAudio support in nixpkgs applications
	# nixpkgs.config.pulseaudio = true;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};
	nixpkgs.config.pipewire = true;
}
