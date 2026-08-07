{ config, pkgs, lib, ... } : {
	imports = [
		./disko.nix

		../../services/hardware/efi.nix
		../../services/hardware/amdcpu.nix
		../../services/hardware/amdgpu.nix
		../../services/hardware/ssd.nix
		# ../../services/hardware/bluetooth.nix
		../../services/hardware/sound.nix
		# ../../services/hardware/secureboot.nix
		# ../../services/hardware/rtl-sdr.nix

		../../services/base.nix
	];

	boot = {
		initrd.availableKernelModules = [
			"nvme"
			"ehci_pci"
			"xhci_pci"
			"usb_storage"
			"usbhid"
		];

		loader = {
			timeout = 2;
			systemd-boot = {
				enable = true;
				configurationLimit = 10;
			};
		};
	};

	impermanence = {
		enable = false;
		rootFileSystem = {
			btrfsSubvolume = "impermanent_root";
			device = "/dev/lvm_pool/nixos";
		};
		persistentFilesystem = {
			btrfsSubvolume = "persist";
			mountPoint = "/mnt/persist";
		};
		users = [ "me" ];
		persistence.directories = [
			"/root/hashed-passwords/"
		];
	};

	# users = {
		# mutableUsers = false;
		# users.me.hashedPasswordFile = "/root/hashed-passwords/dominic";
	# };

	nix.settings.max-jobs = 16;
	system.stateVersion = mkDefault "26.05";
}
