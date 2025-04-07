{ lib, config, ... }:
let
	inherit (lib) mkEnableOption mkIf mkOption types;

	prependList = pre: list: map (post: "${pre}${post}") list;

	cfg = config.impermanence;
in
{
	options.impermanence = {

		enable = mkEnableOption "Enables impermanence module";

		rootFileSystem = mkOption {
			type = types.submodule {
				options = {
					btrfsSubvolume = mkOption {
						type = types.str;
					};
					device = mkOption {
						type = types.path;
					};
				};
			};
		};

		persistentFilesystem = mkOption {
			type = types.submodule {
				options = {
					btrfsSubvolume = mkOption {
						type = types.str;
					};
					mountPoint = mkOption {
						type = types.path;
					};
				};
			};
		};
	};

	config = mkIf cfg.enable {

		fileSystems = {
			"${cfg.persistentFilesystem.mountPoint}".neededForBoot = true;
			"/" = {
				device = cfg.rootFileSystem.device;
				fsType = "btrfs";
				options = [ "subvol=/${cfg.rootFileSystem.btrfsSubvolume}" ];
			};
		};

		boot.initrd.postDeviceCommands = lib.mkAfter ''
			btrfstmp="/impermanence"
			mkdir "$btrfstmp"
			mount "${cfg.rootFileSystem.device}" "$btrfstmp"
			if [[ -e "$btrfstmp/${cfg.rootFileSystem.btrfsSubvolume}" ]]; then
				mkdir -p "$btrfstmp/old_roots"
				timestamp=$(date --date="@$(stat -c %Y "$btrfstmp/${cfg.rootFileSystem.btrfsSubvolume}")" --utc "+%Y-%m-%dT%H:%M:%SZ")
				mv "$btrfstmp/${cfg.rootFileSystem.btrfsSubvolume}" "$btrfstmp/old_roots/$timestamp"
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

			btrfs subvolume create "$btrfstmp/${cfg.rootFileSystem.btrfsSubvolume}"
			umount "$btrfstmp"
		'';

		environment.persistence."${cfg.persistentFilesystem.mountPoint}" = {
			hideMounts = true;
			files = (prependList "/etc/" [
				"machine-id"
				"wpa_supplicant.conf"
			]);
			directories = [
				config.boot.lanzaboote.pkiBundle
			] ++ (prependList "/var/" ([
					"log"
				] ++ (prependList "lib/" [
					"alsa"
					"bluetooth"
					"fprint"
					"nixos"
					"systemd"
				])
			));
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
					".gnupg"
					".mozilla/firefox"
					# ".wine"
				] ++ (prependList ".config/" [
					"discord"
					"dconf"
					"gtk-2.0"
					"gtk-3.0"
					# "gh"
					"Thunar"
					"xfce4"
				]) ++ (prependList ".cache/" [
					# "wine"
					# "winetricks"
					"zsh"
					"nix"
					"mozilla/firefox"
				]);
			};
		};
	};
}
