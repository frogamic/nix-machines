let
	inherit ((import ../../lib).disko) lvmOnLuks btrfsWithSubvols;
in
{
	disko.devices = {
		disk = {
			nixos = lvmOnLuks {
				device = "/dev/disk/by-id/nvme-eui.002538b90150619b";
				name = "nixos";
				extraPartitions = {
					ESP = {
						size = "1G";
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
			data = lvmOnLuks {
				device = "/dev/disk/by-id/nvme-eui.002538b63140b95f";
				name = "data";
			};
		};
		lvm_vg = {
			lvm_nixos = btrfsWithSubvols {
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
					nix.mountpoint = "/nix";
					persist.mountpoint = "/mnt/persist";
					var_log.mountpoint = "/var/log";
				};
				extraLvs = {
					swap = {
						size = "16G";
						content.type = "swap";
					};
				};
			};
			lvm_data = btrfsWithSubvols {
				name = "data";
				subvolumes = {
					data.mountpoint = "/mnt/data";
					cache.mountpoint = "/mnt/cache";
					var_lib_steam.mountpoint = "/var/lib/steam";
				};
			};
		};
	};
}
