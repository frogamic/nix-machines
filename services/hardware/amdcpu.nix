{ config, lib, ... } : {
	boot.kernelModules = [ "kvm-amd" ];
	hardware = {
		cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
		enableRedistributableFirmware = true;
	};
}
