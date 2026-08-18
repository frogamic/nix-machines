{ config, lib, pkgs, ... }:
let
	inherit (lib) mkIf optionals mkEnableOption mkOption types;

	cfg = config.programs.lm_sensors;
in
{
	options.programs.lm_sensors = {

		enable = mkEnableOption "lm_sensors: tools for reading hardware sensors";

		package = mkOption {
			description = "The lm_sensors package to use";
			default = pkgs.lm_sensors;
			type = types.package;
		};

		config = mkOption {
			description = "lm_sensors configuration to use";
			default = "";
			example = ''
			'';
			type = types.separatedString "\n";
		};

		kernelModules = mkOption {
			description = "Extra kernel modules needed to access sensor hardware";
			default = [];
			example = [
				"jc42"
				"nct6683"
			];
			type = types.listOf types.str;
		};

	};

	config = mkIf cfg.enable {
		boot.kernelModules = cfg.kernelModules;

		environment = {
			systemPackages = [ cfg.package ];
			etc."sensors3.conf".text = cfg.config;
		};
	};
}

