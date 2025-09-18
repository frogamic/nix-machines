{ pkgs, ... } : {
	imports = [ ./backlight.nix ];
	services.tlp.enable = true;
	impermanence.persistence.directories = [
		"/var/lib/tlp"
	];
}
