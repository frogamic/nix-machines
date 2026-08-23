{ lib, pkgs, config, ... } : let
	inherit (lib) mkDefault;
in {

	imports = [
		../users/me.nix

		./hardware/nitrokey.nix
		./hardware/flipper.nix

		./login.nix
		./nixFlakes.nix
		./emulatedSystems.nix
		./ssh.nix
		./fonts.nix
		./sway.nix
		./desktop-apps.nix
		./develop.nix
		./android.nix
		./graphics.nix
		# ./3dprinting.nix
	];

	networking = mkDefault {
		useDHCP = true;
		useNetworkd = true;
	};

	boot = {
		supportedFilesystems = [ "ntfs" ];
		kernelPackages = mkDefault pkgs.linuxPackages_latest;
	};

	programs = {
		gnupg.agent.enable = true;
		fzf = {
			fuzzyCompletion = true;
			keybindings = true;
		};
		nix-index-database.comma.enable = true;
	};

	environment.inputrc.extraConfig = ''
		set editing-mode vi
	'';

	environment.systemPackages = with pkgs; [
		openssl
		curl
		zip
		unzip
		unar
		p7zip
		stow
		lsof
		bind
		parted
		ripgrep
		file
		python3Packages.yq
		jq
		yj
		bat
		tree
		killall
		pstree
		pv
		pciutils
		usbutils
		ffmpeg
		nix-index
		exfat
	];

	services = {
		fwupd.enable = true;
		btrfs.autoScrub.enable = mkDefault (
			lib.lists.any
				(x: x.fsType == "btrfs")
				(lib.attrsets.attrValues config.fileSystems)
		);
	};

	nix.settings.auto-optimise-store = true;
	system.stateVersion = mkDefault "26.05"; # Did you read the comment?

	users.users.root.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8rVaDV6tjSjVTrigsVnanK7rPf4FHl4qMpHSeO2j9b dominic@enlil"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5rpMMLWs8oQXYtg9wXuvsb70O0vtPX+KEK1KiJAZVO dominic@ninhursag"
	];

	impermanence.persistence = {
		files = [
			"/etc/machine-id"
		];
		directories = [
			"/var/lib/nixos"
			"/var/lib/systemd"
			"/var/lib/btrfs"
			"/var/lib/fwupd"
			"/var/cache/fwupd"
		];
		user = {
			files = [
				".config/nix/nix.conf"
			];
			directories = [
				"Desktop"
				"Documents"
				"Downloads"
				"Music"
				"Pictures"
				"Videos"
				"repos"
				".ssh"
				".gnupg"
				# ".wine"
				".config/dconf"
				".config/gtk-2.0"
				".config/gtk-3.0"
				# ".config/gh"
				".config/xfce4"
				# ".cache/wine"
				# ".cache/winetricks"
				".cache/nix"
			];
		};
	};
}
