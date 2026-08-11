{ config, lib, pkgs, ... }:

let
	inherit (lib) mkIf mkEnableOption;

	backlightctl = pkgs.writeScriptBin "backlightctl" (builtins.readFile ./backlightctl.sh);

	cfg = config.mine.hardware.backlightctl;
in

{
	options.mine.hardware.backlightctl.enable = mkEnableOption "Backlight control helper script";

	config = mkIf cfg.enable {
		environment.systemPackages = [
			pkgs.brightnessctl
			backlightctl
		];
	};
}
