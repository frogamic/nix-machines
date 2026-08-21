{ config, lib, ... }:

let
	inherit (lib) mkIf mkEnableOption;

	cfg = config.mine.hardware.amdcpu;
in

{
	options.mine.hardware.amdcpu = {
		enable = mkEnableOption "AMD CPU defaults";
	};

	config = mkIf cfg.enable {
		hardware = {
			cpu.amd.updateMicrocode = true;
			enableRedistributableFirmware = true;
		};

		boot = {
			blacklistedKernelModules = [ "k10temp" ];
			extraModulePackages = with config.boot.kernelPackages; [
				zenpower
			];
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

	};
}
