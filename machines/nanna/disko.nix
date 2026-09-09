let
	inherit ((import ../../lib).disko) lvmOnLuks btrfsWithSubvols;
in
{
	disko.devices = {
		disk = {
			nixos = lvmOnLuks {
				device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4c9b9eb6";
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
		};
		lvm_vg = {
			lvm_nixos = btrfsWithSubvols {
				name = "nixos";
				subvolumes = {
					root.mountpoint = "/";
				};
				extraLvs = {
					swap = {
						size = "16G";
						content.type = "swap";
					};
				};
			};
		};
	};
}
