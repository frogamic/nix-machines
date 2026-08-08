let
  lvmOnLuks = { device, name, partitions }: {
		inherit device;
		type = "disk";
		content = {
			type = "gpt";
			partitions = partitions // {
				"luks_${name}" = {
					size = "100%";
					content = {
						type = "luks";
						name = "luks_${name}";
						settings = {
							allowDiscards = true;
							bypassWorkqueues = true;
						};
						content = {
							type = "lvm_pv";
							vg = "lvm_${name}";
						};
					};
				};
			};
		};
	};
	btrfsWithSubvols = {name, subvolumes, lvs} : {
		type = "lvm_vg";
		lvs = {
			"${name}" = {
				size = "100%FREE";
				content = {
					inherit subvolumes;
					type = "btrfs";
					extraArgs = [ "-f" ];
					mountOptions = [
						"compress=zstd"
						"noatime"
					];
				};
			};
		} // lvs;
	};
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
				device = "/dev/disk/by-id/wwn-0x5002538e49637928";
				name = "persist";
				partitions = {};
			};
			steam = lvmOnLuks {
				device = "/dev/disk/by-id/wwn-0x5002538e49637a4f";
				name = "steam";
				partitions = {};
			};
		};
		lvm_vg = {
			lvm_nixos = btrfsWithSubvols {
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
					nix.mountpoint = "/nix";
				};
				lvs = {};
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
						content = {
							type = "swap";
							#discardPolicy = "both";
						};
					};
				};
			};
			lvm_steam = btrfsWithSubvols {
				name = "steam";
				subvolumes = {
					var_lib_steam.mountpoint = "/var/lib/steam";
				};
				lvs = {};
			};
		};
	};
}
