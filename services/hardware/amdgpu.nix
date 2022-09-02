{ config, pkgs, ... } : {
	boot.initrd.kernelModules = [ "amdgpu" ];
	services.xserver = {
		videoDrivers = [ "AMDGPU" ];
	};
	hardware.opengl = {
		enable = true;
		driSupport = true;
		driSupport32Bit = true;
		extraPackages32 = with pkgs.driversi686Linux; [
			amdvlk
		];
		extraPackages = with pkgs; [
			amdvlk
			rocm-opencl-icd
			rocm-opencl-runtime
		];
	};
}
