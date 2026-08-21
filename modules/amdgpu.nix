{ config, lib, pkgs, ... }:

let
	inherit (lib) mkBefore mkIf mkEnableOption mkOption types;

	mkDisableOption = name: mkOption {
		default = true;
		example = false;
		description = "Whether to enable ${name}";
		type = types.bool;
	};

	cfg = config.mine.hardware.amdgpu;
in

{
	options.mine.hardware.amdgpu = {

		enable = mkEnableOption "AMDGPU driver with defaults";

		enable32Bit = mkDisableOption "32 bit graphics support";

		enableOpenCl = mkDisableOption "ROCm openCL support";

		enableGuiTools = mkDisableOption "GUI tools for GPU management";

		enableOverdrive = mkDisableOption "ppfeaturemask for overclocking";

	};

	config = mkIf cfg.enable {

		environment.systemPackages = with pkgs; [
			radeontop
			amdgpu_top
		];

		programs.lm_sensors.config = ''
chip "amdgpu-pci-*"
	label temp1 "GPU Edge"
	label temp2 "GPU Hotspot"
	label temp3 "GPU Memory"
	label fan1 "GPU Fan"
	label in0 "GPU Core Voltage"
	label power1 "GPU Power (PPT)"
	label freq1 "GPU Core Clock"
	label freq2 "GPU Memory Clock"
	label pwm1 "GPU Fan %"
'';

		services = {

			lact.enable = cfg.enableGuiTools;

			xserver = {
				videoDrivers = mkBefore [
					"amdgpu"
				];
			};

		};

		hardware = {

			graphics = {
				inherit (cfg) enable32Bit;
			};

			amdgpu = {
				initrd.enable = true;
				overdrive.enable = cfg.enableOverdrive;
				opencl.enable = cfg.enableOpenCl;
			};

		};

		impermanence.persistence.user.directories = [
			".cache/radv_builtin_shaders"
		];

	};
}
