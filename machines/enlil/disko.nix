let
	inherit ((import ../../lib).disko) btrfsOnLuks;
	hostName = "enlil";
in
{
	disko.devices = {
		disk = {
			"${hostName}-nixos" = btrfsOnLuks {
				device = "/dev/disk/by-id/nvme-eui.002538b90150619b";
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
					nix.mountpoint = "/nix";
					persist.mountpoint = "/mnt/persist";
					var_log.mountpoint = "/var/log";
				};
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
			"${hostName}-data" = btrfsOnLuks {
				device = "/dev/disk/by-id/nvme-eui.002538b63140b95f";
				name = "data";
				subvolumes = {
					data.mountpoint = "/mnt/data";
					cache.mountpoint = "/mnt/cache";
					games.mountpoint = "/mnt/games";
				};
			};
		};
	};
}
