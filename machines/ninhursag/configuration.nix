{ config, pkgs, lib, ... } : {
	imports = [
		./disko.nix

		../../services/hardware/efi.nix
		../../services/hardware/amdcpu.nix
		../../services/hardware/amdgpu.nix
		../../services/hardware/ssd.nix
		../../services/hardware/laptop.nix
		../../services/hardware/bluetooth.nix
		../../services/hardware/sound.nix
		../../services/hardware/fingerprint.nix
		../../services/hardware/secureboot.nix
		../../services/hardware/rtl-sdr.nix

		../../services/base.nix
	];

	boot = {
		initrd.availableKernelModules = [
			"nvme"
			"ehci_pci"
			"xhci_pci"
			"usb_storage"
			"sd_mod"
			"rtsx_pci_sdmmc"
			"thinkpad_acpi"
		];
		kernelParams = [ "acpi_backlight=native" ];
		kernelPackages = pkgs.linuxPackages_latest;

		loader = {
			timeout = 2;
			systemd-boot = {
				enable = true;
				configurationLimit = 10;
			};
		};
	};

	impermanence = {
		enable = true;
		rootFileSystem = {
			btrfsSubvolume = "impermanent_root";
			device = "/dev/lvm_pool/nixos";
		};
		persistentFilesystem = {
			btrfsSubvolume = "persist";
			mountPoint = "/mnt/persist";
		};
	};

	networking = {
		wireless.enable = false;
		supplicant.wlp3s0 = {
			userControlled.enable = true;
			configFile = {
				path = "/etc/wpa_supplicant.conf";
				writable = true;
			};
		};
	};

	services = {
		libinput.touchpad.middleEmulation = false;
		xserver.xkb.options = pkgs.mylib.mkDefault "altwin:prtsc_rwin";
	};
	hardware.trackpoint = {
		enable = true;
		emulateWheel = true;
	};

	nix.settings.max-jobs = 16;
}
