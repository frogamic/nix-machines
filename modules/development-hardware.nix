{ config, lib, pkgs, ... }:

let
	inherit (lib) mkIf mkEnableOption optional optionals;
	cfg = config.mine.development.hardware;
in

{
	options.mine.development.hardware = {
		enable = mkEnableOption "Standard hardware devtool installation";
	};

	config = mkIf cfg.enable {
		environment.systemPackages = (with pkgs; [
			dfu-util
			platformio
		]);

		programs.flashrom.enable = true;

		users.users.me.extraGroups = [ "flashrom" ];
	};
}
