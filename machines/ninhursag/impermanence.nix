{ lib, config, ... }:
let
	persist = rec {
		subvolume = "persist";
		mount = "/mnt/persist";
	};
	root = {
		subvolume = "impermanent_root";
		volume = "nixos";
		pool = "lvm_pool";
		vg = "lvm_vg";
	};
in
{
	# disko.devices."${root.vg}"."${root.pool}".lvs."${root.volume}".content.subvolumes."${persist.subvolume}".mountpoint = persist.mount;

	fileSystems."${persist.mount}".neededForBoot = true;

	boot.initrd.postDeviceCommands = lib.mkAfter ''
		btrfstmp="/impermanence"
		mkdir "$btrfstmp"
		mount "/dev/${root.pool}/${root.volume}" "$btrfstmp"
		if [[ -e "$btrfstmp/${root.subvolume}" ]]; then
			mkdir -p "$btrfstmp/old_roots"
			timestamp=$(date --date="@$(stat -c %Y "$btrfstmp/${root.subvolume}")" --utc "+%Y-%m-%dT%H:%M:%SZ")
			mv "$btrfstmp/${root.subvolume}" "$btrfstmp/old_roots/$timestamp"
		fi

		delete_subvolume_recursively() {
			IFS=$'\n'
			for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
				delete_subvolume_recursively "$btrfstmp/$i"
			done
			btrfs subvolume delete "$1"
		}

		for i in $(find $btrfstmp/old_roots/ -maxdepth 1 -mtime +30); do
			delete_subvolume_recursively "$i"
		done

		btrfs subvolume create "$btrfstmp/${root.subvolume}"
		umount "$btrfstmp"
	'';

	environment.persistence."${persist.mount}" = {
		hideMounts = true;
		files = [
			"/etc/machine-id"
			"/etc/wpa_supplicant.conf"
		];
		directories = [
			"/etc/secureboot"
			"/var/log"
			"/var/lib/bluetooth"
			"/var/lib/fprint"
			"/var/lib/nixos"
			"/var/lib/systemd"
		];
		users.me = {
			home = "/home/dominic";
			directories = [
				"Desktop"
				"Documents"
				"Downloads"
				"Music"
				"Pictures"
				"repos"
				"Videos"
				".ssh"
			];
		};
	};
}
