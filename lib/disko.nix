{
	lvmOnLuks = {
		device,
		name,
		extraPartitions ? {},
	}: {
		inherit device;
		type = "disk";
		content = {
			type = "gpt";
			partitions = extraPartitions // {
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

	btrfsWithSubvols = {
		name,
		subvolumes,
		extraLvs ? {},
	} : {
		type = "lvm_vg";
		lvs = extraLvs // {
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
		};
	};
}
