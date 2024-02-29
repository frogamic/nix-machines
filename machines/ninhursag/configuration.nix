{ config, pkgs, lib, ... } : {
	imports = [
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

	networking = {
		wireless.enable = false;
		interfaces = {
			wlp3s0.useDHCP = true;
			enp2s0f0.useDHCP = true;
		};
		supplicant.wlp3s0 = {
			userControlled.enable = true;
			configFile = {
				path = "/etc/wpa_supplicant.conf";
				writable = true;
			};
		};
	};

	services.xserver = {
		xkb.options = pkgs.mylib.mkDefault "altwin:prtsc_rwin";
		libinput.touchpad.middleEmulation = false;
	};
	hardware.trackpoint = {
		enable = true;
		emulateWheel = true;
	};

	boot.initrd.luks.devices.cryptroot = {
		device = "/dev/disk/by-uuid/94750b3e-4442-4491-8637-5f46363c3750";
		preLVM = true;
		allowDiscards = true;
		bypassWorkqueues = true;
		preOpenCommands = ''
			echo 100 > /sys/class/backlight/amdgpu_bl0/brightness
			echo 1 > /sys/class/leds/tpacpi::kbd_backlight/brightness
		'';
	};

	fileSystems = {
		"/" = {
			device = "/dev/disk/by-uuid/54713050-50cc-4ed1-864d-e9d28b6c92d9";
			fsType = "btrfs";
			options = [ "autodefrag" "noatime" ];
		};

		"/efi" = {
			device = "/dev/disk/by-uuid/6333-886D";
			fsType = "vfat";
		};
	};

	swapDevices = [
		{ device = "/dev/disk/by-uuid/37885878-19c4-4b10-857e-80e0c989057a"; }
	];

	nix.settings.max-jobs = 16;
}
