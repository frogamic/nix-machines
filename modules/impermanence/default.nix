{ pkgs, lib, config, ... }:
let
	inherit (builtins) listToAttrs readFile;
	inherit (lib) mkEnableOption mkIf mkOption types;

	cfg = config.impermanence;
in
{
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
			type = listOf str;
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

		boot.initrd.systemd = {
			services.impermanence-root = {
				description = "Create and archive root subvolume";
				unitConfig.DefaultDependencies = false;
				serviceConfig = {
					Type = "oneshot";
					StandardOutput = "journal+console";
					StandardError = "journal+console";
				};
				requiredBy = [ "initrd.target" ];
				before = [ "sysroot.mount" ];
				requires = [ "initrd-root-device.target" ];
				after = [
					"initrd-root-device.target"
					"local-fs-pre.target"
				];
				environment = {
					BTRFSTMP = "/impermanence";
					OLDROOTS = "old_roots";
					ROOTDEVICE = cfg.rootFileSystem.device;
					ROOTSUBVOLUME = cfg.rootFileSystem.btrfsSubvolume;
				};
				script = readFile ./rolling-root.sh;
			};
			extraBin = {
				"mkdir" = "${pkgs.coreutils}/bin/mkdir";
				"date" = "${pkgs.coreutils}/bin/date";
				"stat" = "${pkgs.coreutils}/bin/stat";
				"mv" = "${pkgs.coreutils}/bin/mv";
				"find" = "${pkgs.findutils}/bin/find";
				"btrfs" = "${pkgs.btrfs-progs}/bin/btrfs";
			};
		};

		environment = {
			systemPackages = [
				(pkgs.writeScriptBin "impermanence-diff" (readFile ../../bin/impermanence-diff))
			];
			persistence."${cfg.persistentFilesystem.mountPoint}" = {
				inherit (cfg.persistence) files directories;
				hideMounts = true;
				users = listToAttrs (map (user: {
					name = user;
					value = {
						inherit (cfg.persistence.user) files directories;
					};
				}) cfg.users);
			};
		};
	};
}
