{ lib, ... } : rec {
	boot.loader.efi = {
		canTouchEfiVariables = true;
		efiSysMountPoint = "/efi";
	};
	fileSystems."${boot.loader.efi.efiSysMountPoint}" = {
		fsType = lib.mkDefault "vfat";
	};
}
