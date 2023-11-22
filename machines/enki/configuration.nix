{ config, pkgs, ... } : {
	imports = [
		../../services/hardware/efi.nix
		../../services/hardware/amdcpu.nix
		../../services/hardware/amdgpu.nix
		../../services/hardware/ssd.nix
		../../services/hardware/bluetooth.nix
		../../services/hardware/sound.nix

		../../services/base.nix
		../../services/texlive.nix
	];

	boot = {
		initrd.availableKernelModules = [
			"nvme"
			"xhci_pci"
			"ahci"
			"usbhid"
		];

		loader.grub = {
			default = "saved";
			efiSupport = true;
			device = "nodev";
			useOSProber = true;
			gfxmodeEfi = "1920x1200";
			splashImage = null;
			extraEntries = ''
menuentry "UEFI Firmware Setup" {
fwsetup
}
			'';
		};
	};

	networking = {
		interfaces.enp4s0.useDHCP = true;
	};

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/389c0259-8dbe-4efd-9693-ddeedf66defe";
			fsType = "ext4";
		};
		"/home" = {
			device = "/dev/disk/by-uuid/421aae2b-d64b-4e8f-a5bd-8e4c79f3b4ae";
			fsType = "ext4";
		};
		"${config.boot.loader.efi.efiSysMountPoint}" = {
			device = "/dev/disk/by-uuid/0D39-C351";
			fsType = "vfat";
		};
	};

	swapDevices = [
		{ device = "/dev/disk/by-uuid/a02708dd-61b9-4405-b49b-863494d06c37"; }
	];

	nix.settings.max-jobs = 16;
}
