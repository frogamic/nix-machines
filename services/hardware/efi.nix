{ lib, ... } : {
	boot.loader.efi = {
		canTouchEfiVariables = true;
		efiSysMountPoint = "/efi";
	};
	fileSystems."/efi" = {
		fsType = lib.mkDefault "vfat";
	};
}
