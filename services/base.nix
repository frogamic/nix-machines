{ lib, pkgs, ... } : {

	imports = [
		./nixFlakes.nix
		./updates.nix
		./emulatedSystems.nix
		./sound.nix
		./ssh.nix
		./fonts.nix
		./sway.nix
		./desktop-apps.nix
		./develop.nix
		./android.nix
		./steam.nix
	];

	networking.useDHCP = lib.mkDefault false;
	boot.supportedFilesystems = [ "ntfs" ];
	time.timeZone = "Australia/Melbourne";
	i18n.defaultLocale = "en_AU.UTF-8";

	services.xserver = {
		layout = "dvorak,us";
		xkbOptions = "caps:swapescape";
	};

	console = {
		font = "Lat2-Terminus16";
		useXkbConfig = true;
	};

	programs.zsh.enable = true;

	environment.etc.inputrc.text = lib.mkForce (
		''
			set editing-mode vi
		''
		+ pkgs.GodFuckingDamnitInputrcIsPartOfLibreadlineNotBash.inputrc
	);

	environment = {
		shellAliases = {
			ll = "ls -alh";
			ns = "function _ns() { nix-shell -p \"$1\" --run \"$*\"; }; _ns";
		};
		variables = {
			EDITOR = "vim";
		};

		systemPackages = with pkgs; [
			openssl
			curl
			zip
			unzip
			stow
			lsof
			bind
			parted
			ripgrep
			file
			jq
			bat
			tree
			killall
			pstree
			pciutils
			usbutils
			ffmpeg
			nix-index
		];
	};

	services.fwupd = {
		enable = true;
		enableTestRemote = true;
	};

	nix.autoOptimiseStore = true;
}
