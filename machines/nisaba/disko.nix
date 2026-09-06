let
	inherit ((import ../../lib).disko) lvmOnLuks btrfsWithSubvols;
in
{
	disko.devices = {
		disk = {
			nixos = lvmOnLuks {
				device = "/dev/disk/by-id/nvme-eui.0025388691b07e28";
				name = "nixos";
				extraPartitions = {
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
			data = lvmOnLuks {
				device = "/dev/disk/by-id/nvme-eui.0025384431401332";
				name = "data";
			};
		};
		lvm_vg = {
			lvm_nixos = btrfsWithSubvols {
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
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
