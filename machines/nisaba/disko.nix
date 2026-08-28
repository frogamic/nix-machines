let
	inherit ((import ../../lib).disko) lvmOnLuks btrfsWithSubvols;
in
{
	disko.devices = {
		disk = {
			nixos = lvmOnLuks {
				device = "/dev/disk/by-id/nvme-eui.0025388691b07e28";
				name = "nixos";
				partitions = {
					ESP = {
						size = "512M";
						type = "EF00";
						content = {
							type = "filesystem";
							format = "vfat";
							mountpoint = "/efi";
							mountOptions = [
								"defaults"
								"fmask=0077"
								"dmask=0077"
							];
						};
					};
				};
			};
			persist = lvmOnLuks {
				device = "wwn-0x5002538e49637928";
				name = "persist";
			};
			steam = lvmOnLuks {
				device = "wwn-0x5002538e49637a4f";
				name = "steam";
			};
		};
		lvm_vg = {
			lvm_nixos = btrfsWithSubvols {
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
					nix.mountpoint = "/nix";
				};
			};
			lvm_persist = btrfsWithSubvols {
				name = "persist";
				subvolumes = {
					persist.mountpoint = "/mnt/persist";
					cache.mountpoint = "/mnt/cache";
					var_log.mountpoint = "/var/log";
				};
				lvs = {
					swap = {
						size = "16G";
						content.type = "swap";
					};
				};
			};
			lvm_steam = btrfsWithSubvols {
				name = "steam";
				subvolumes = {
					var_lib_steam.mountpoint = "/var/lib/steam";
				};
			};
		};
	};
}
