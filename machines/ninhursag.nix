overlays : rec {
	system = "x86_64-linux";
	modules = [
		(overlays system)
		({ config, pkgs, ... } : {
			networking.hostName = "ninhursag";

			imports = [
				../services/hardware/efi.nix
				../services/hardware/amdcpu.nix
				../services/hardware/amdgpu.nix
				../services/hardware/ssd.nix
				../services/hardware/laptop.nix
				../services/hardware/bluetooth.nix
				../services/hardware/fingerprint.nix

				../services/base.nix

				../users/dominic.nix
			];

			boot = {
				initrd.availableKernelModules = [
					"nvme"
					"ehci_pci"
					"xhci_pci"
					"usb_storage"
					"sd_mod"
					"rtsx_pci_sdmmc"
				];
				kernelParams = [ "acpi_backlight=native" ];
				kernelPackages = pkgs.linuxPackages_latest;

				loader = {
					timeout = 2;
					systemd-boot.enable = true;
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

			hardware.trackpoint = {
				enable = true;
				emulateWheel = true;
			};

			fileSystems."/" = {
				device = "/dev/disk/by-uuid/3605938b-fc96-44f8-94c7-424426b76314";
				fsType = "ext4";
			};

			fileSystems."/efi" = {
				device = "/dev/disk/by-uuid/6333-886D";
				fsType = "vfat";
			};

			nix.maxJobs = 16;

			system.stateVersion = "20.09"; # Did you read the comment?
		})
	];
}
