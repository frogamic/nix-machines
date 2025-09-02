{ lib, config, ... }:
let
	inherit (builtins) listToAttrs;
	inherit (lib) mkEnableOption mkIf mkOption types;

	cfg = config.impermanence;
in
{
	imports = (import ../../lib/getImportable.nix ./.);

	options.impermanence = with types; {

		enable = mkEnableOption "Enables impermanence module";

		rootFileSystem = mkOption {
			type = submodule {
				options = {
					btrfsSubvolume = mkOption {
						type = str;
					};
					device = mkOption {
						type = path;
					};
				};
			};
		};

		persistentFilesystem = mkOption {
			type = submodule {
				options = {
					btrfsSubvolume = mkOption {
						type = str;
					};
					mountPoint = mkOption {
						type = path;
					};
				};
			};
		};

		users = mkOption {
			type = listOf (
				submodule {
					options = {
						key = mkOption {type = str;};
						home = mkOption {type = path;};
					};
				}
			);
		};

		persistence = mkOption {
			type = submodule {
				options = {
					files = mkOption {
						type = listOf anything;
					};
					directories = mkOption {
						type = listOf anything;
					};
					user = mkOption {
						type = submodule {
							options = {
								files = mkOption {
									type = listOf anything;
								};
								directories = mkOption {
									type = listOf anything;
								};
							};
						};
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
			inherit (cfg.persistence) files directories;
			hideMounts = true;
			users = listToAttrs (map (user: {
				name = user.key;
				value = {
					inherit (user) home;
					inherit (cfg.persistence.user) files directories;
				};
			}) cfg.users);
		};
	};
}
