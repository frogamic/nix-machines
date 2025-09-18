{ pkgs, ... } : {
	hardware.bluetooth.enable = true;
	environment.systemPackages = [
		(pkgs.writeScriptBin "hp" (builtins.readFile ../../bin/headphones))
	];
	impermanence.persistence.directories = [
		"/var/lib/bluetooth"
	];
}
