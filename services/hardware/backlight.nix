{ pkgs, ... } : let
	backlightctl = pkgs.writeScriptBin "backlightctl" (builtins.readFile ../../bin/backlightctl);
in {
	environment.systemPackages = [
		pkgs.brightnessctl
		backlightctl
	];
}
