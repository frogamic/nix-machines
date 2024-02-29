{ pkgs, ... } : {
	hardware.bluetooth.enable = true;
	environment.systemPackages = [
		(pkgs.writeScriptBin "hp" (builtins.readFile ../../bin/headphones))
	];
}
