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
		autoUpgrade = {
			enable = true;
			flake = "github:frogamic/nix-machines?ref=feature/jovian";
		};
		jovian.enable = true;
		localAiServer.enable = true;
	};

	system.autoUpgrade.operation = "boot";

	programs.lm_sensors = {
		enable = true;
		package = pkgs.mypkgs.lm_sensors;
		kernelModules = [
			"nct6775"
			"drivetemp"
		];
		config = builtins.readFile ./sensors3.conf;
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

	environment.loginShellInit = "";

	systemd.sleep.settings.Sleep = {
		AllowHibernation = "no";
		AllowHybridSleep = "no";
		AllowSuspend = "no";
		AllowSuspendThenHibernate = "no";
	};
}
