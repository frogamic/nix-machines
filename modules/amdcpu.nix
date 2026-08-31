{ config, lib, ... }:

let
	inherit (lib) mkIf mkEnableOption mkOption optionals types;

	cfg = config.mine.hardware.amdcpu;
in

{
	options.mine.hardware.amdcpu = with types; {
		enable = mkEnableOption "AMD CPU defaults";
		voltageOffset = mkOption {
			default = 0;
			example = -30;
			description = "Set a cpu core voltage offset (e.g. undervolt) in millivolts";
			type = int;
		};
	};

	config = mkIf cfg.enable {
		hardware = {
			cpu.amd.updateMicrocode = true;
			enableRedistributableFirmware = true;
		};

		boot = {
			blacklistedKernelModules = [ "k10temp" ];
			extraModulePackages = with config.boot.kernelPackages; ([
				zenpower
			] ++ (optionals (cfg.voltageOffset != 0) [
				ryzen-smu
			]));
		};

		programs.lm_sensors = {
			kernelModules = [ "zenpower" ];
			config = ''
chip "zenpower-pci-*"
	label temp1 "CPU die"
	label temp2 "CPU Tctl"
	label temp3 "CPU CCD1"
	label in1 "CPU Core Voltage"
	label in2 "CPU SoC Voltage"
	label power1 "CPU Core Power"
	label power2 "CPU SoC Power"
	label curr1 "CPU Core Amps"
	label curr2 "CPU SoC Amps"
'';
		};

		# systemd.services.ryzen-smu-voltage-offset = {
		# 	serviceConfig = {
		# 		Type = "oneshot";
		# 		ExecStart = 
		# };

	};
}
