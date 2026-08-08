{
	disko.devices = {
		disk.primary = {
			type = "disk";
			device = "/dev/disk/by-id/nvme-eui.002538b90150619b";
			content = {
				type = "gpt";
				partitions = {
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
					luks_root = {
						size = "100%";
						content = {
							type = "luks";
							name = "luks_root";
							settings = {
								allowDiscards = true;
								bypassWorkqueues = true;
							};
							content = {
								type = "lvm_pv";
								vg = "lvm_pool";
							};
						};
					};
				};
			};
		};
		lvm_vg.lvm_pool = {
			type = "lvm_vg";
			lvs = {
				nixos = {
					size = "100%FREE";
					content = {
						type = "btrfs";
						extraArgs = [ "-f" ];
						mountOptions = [
							"compress=zstd"
							"noatime"
						];
						subvolumes = {
							root.mountpoint = "/";
							nix.mountpoint = "/nix";
							persist.mountpoint = "/mnt/persist";
							var_log.mountpoint = "/var/log";
							var_lib_steam.mountpoint = "/var/lib/steam";
						};
					};
				};
				swap = {
					size = "16G";
					content = {
						type = "swap";
						#discardPolicy = "both";
					};
				};
			};
		};
	};
}
