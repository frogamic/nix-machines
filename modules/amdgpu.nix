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
