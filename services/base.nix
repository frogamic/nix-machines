{ lib, pkgs, ... } : {

	imports = [
		../users/me.nix

		./login.nix
		./nixFlakes.nix
		./updates.nix
		./emulatedSystems.nix
		./sound.nix
		./ssh.nix
		./fonts.nix
		./sway.nix
		./desktop-apps.nix
		./develop.nix
		./fzf.nix
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

	environment.inputrc.extraConfig = ''
		set editing-mode vi
	'';

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
			unar
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
	nix.sandboxPaths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];
}
