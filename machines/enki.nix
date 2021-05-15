overlays : rec {
	system = "x86_64-linux";
	modules = [
		(overlays system)
		({ config, pkgs, ... } : {
			networking.hostName = "enki";

			imports = [
				../services/hardware/efi.nix
				../services/hardware/amdcpu.nix
				../services/hardware/amdgpu.nix
				../services/hardware/ssd.nix

				../users/dominic.nix

				../services/base.nix
				../services/grub-savedefault.nix
				../services/texlive.nix
			];

			boot = {
				initrd.availableKernelModules = [
					"nvme"
					"xhci_pci"
					"ahci"
					"usbhid"
				];

				loader.grub = {
					efiSupport = true;
					device = "nodev";
					useOSProber = true;
					gfxmodeEfi = "1920x1200";
					splashImage = null;
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
				"/efi" = {
					device = "/dev/disk/by-uuid/0D39-C351";
					fsType = "vfat";
				};
			};

			swapDevices = [
				{ device = "/dev/disk/by-uuid/a02708dd-61b9-4405-b49b-863494d06c37"; }
			];

			nix.maxJobs = 16;

			system.stateVersion = "20.09";
		})
	];
}
