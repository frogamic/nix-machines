let
	inherit ((import ../../lib).disko) btrfsOnLuks;
	hostName = "nisaba";
in
{
	disko.devices = {
		disk = {
			"${hostName}-nixos" = btrfsOnLuks {
				device = "/dev/disk/by-id/nvme-eui.0025388691b07e28";
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
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
				device = "/dev/disk/by-id/nvme-eui.0025384431401332";
				name = "data";
				subvolumes = {
					nix.mountpoint = "/nix";
					models.mountpoint = "/var/lib/models";
					persist.mountpoint = "/mnt/persist";
					cache.mountpoint = "/mnt/cache";
					data.mountpoint = "/mnt/data";
					games.mountpoint = "/mnt/games";
				};
			};
		};
	};
}
