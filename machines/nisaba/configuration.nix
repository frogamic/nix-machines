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
		jovian.enable = true;
		gaming.enable = true;
	};

	users.users.steam = {
		isNormalUser = true;
		shell = pkgs.zsh;
		openssh.authorizedKeys = config.users.users.me.openssh.authorizedKeys;
	};

	jovian.steam.user = "steam";

	services = {
		desktopManager.plasma6.enable = true;
		iperf3 = {
			enable = true;
			openFirewall = true;
		};
		udev.extraRules = ''
			SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0x2725", ATTR{power/control}="auto"
		'';
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
		blacklistedKernelModules = [
			"iwlwifi"
			"iwlmvm"
		];
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

}
