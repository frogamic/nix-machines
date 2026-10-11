let
	btrfsDefaults = {
		type = "btrfs";
		extraArgs = [ "-f" ];
		mountOptions = [
			"compress=zstd"
			"noatime"
		];
	};
	luksDefaults = {
		type = "luks";
		settings = {
			allowDiscards = true;
			bypassWorkqueues = true;
		};
	};
in

{
	btrfsOnLuks = {
		device,
		name,
		subvolumes,
		extraPartitions ? {},
	}: {
		inherit device;
		type = "disk";
		destroy = false;
		content = {
			type = "gpt";
			partitions = extraPartitions // {
				"crypt" = {
					size = "100%";
					content = luksDefaults // {
						name = "${name}_crypt";
						content = btrfsDefaults // {
							inherit subvolumes;
						};
					};
				};
			};
		};
	};

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
					content = luksDefaults // {
						name = "luks_${name}";
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
				content = btrfsDefaults // {
					inherit subvolumes;
				};
			};
		};
	};
}
