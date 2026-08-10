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
	};
}
