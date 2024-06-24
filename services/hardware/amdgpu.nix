{ config, pkgs, ... } : {
	services.xserver = {
		videoDrivers = [ "amdgpu" ];
	};
	hardware = {
		graphics = {
			enable = true;
			enable32Bit = true;
		};
		amdgpu = {
			initrd.enable = true;
			opencl.enable = true;
			amdvlk = {
				enable = true;
				support32Bit.enable = true;
			};
		};
	};
}
