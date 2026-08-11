{ pkgs, ... } : {
	mine.hardware.backlightctl.enable = true;
	services.tlp.enable = true;
	impermanence.persistence.directories = [
		"/var/lib/tlp"
	];
}
