{ config, pkgs, lib, ... } : {
	imports = [
		./disko.nix

		../../services/hardware/efi.nix
		../../services/hardware/ssd.nix
		../../services/hardware/bluetooth.nix
		../../services/hardware/sound.nix
		../../services/hardware/secureboot.nix

		../../services/base.nix
	];

	mine = {
		hardware = {
			amdgpu.enable = true;
			amdcpu.enable = true;
		};
		autoUpgrade.enable = true;
	};

	system.autoUpgrade.operation = "boot";

	boot = {
		kernelPackages = pkgs.linuxPackages;
		extraModulePackages = [
			config.boot.kernelPackages.nct6687d
		];
	};
	programs.lm_sensors = {
		package = pkgs.mypkgs.lm_sensors;
		enable = true;
		kernelModules = [
			"jc42"
			"nct6687"
		];
		config = ''
chip "k10temp-pci-*"
	label Tctl "CPU Tctl"
	label Tccd1 "CPU CCD1"

chip "amdgpu-pci-*"
	label edge "GPU Edge"
	label junction "GPU Hotspot"
	label mem "GPU Memory"
	label fan1 "GPU Fan"
	label vddgfx "GPU Core Voltage"
	label PPT "GPU Power (PPT)"
	label sclk "GPU Core Clock"
	label mclk "GPU Memory Clock"
	label pwm1 "GPU Fan %"

chip "nvme-pci-0100"
	label temp1 "NVMe 1TB Composite"
	label temp2 "NVMe 1TB Sensor 1"
	label temp3 "NVMe 1TB Sensor 2"

chip "nvme-pci-0400"
	label temp1 "NVMe 2TB Composite"
	label temp2 "NVMe 2TB Sensor 1"
	label temp3 "NVMe 2TB Sensor 2"

bus "i2c-0" "SMBus PIIX4 adapter port 0 at 0b00"
chip "jc42-i2c-0-18"
	label temp1 "DIMM A1"
chip "jc42-i2c-0-19"
	label temp1 "DIMM A2"
chip "jc42-i2c-0-1a"
	label temp1 "DIMM B1"
chip "jc42-i2c-0-1b"
	label temp1 "DIMM B2"
		'';
	};

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
			"/var/lib/passwords/"
		];
	};

	users = {
		mutableUsers = false;
		users.me.hashedPasswordFile = "/var/lib/passwords/me";
	};
}
