{ lib, pkgs, ... } : {

	imports = [
		../users/me.nix

		./hardware/nitrokey.nix
		./hardware/flipper.nix

		./login.nix
		./nixFlakes.nix
		./updates.nix
		./emulatedSystems.nix
		./ssh.nix
		./fonts.nix
		./sway.nix
		./desktop-apps.nix
		./develop.nix
		./fzf.nix
		./android.nix
	];

	networking.useDHCP = lib.mkDefault false;
	boot.supportedFilesystems = [ "ntfs" ];

	programs.gnupg.agent.enable = true;

	environment.inputrc.extraConfig = ''
		set editing-mode vi
	'';

	environment.systemPackages = with pkgs; [
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
		lm_sensors
	];

	services.fwupd = {
		enable = true;
		enableTestRemote = true;
	};

	nix.settings.auto-optimise-store = true;
	system.stateVersion = lib.mkDefault "23.05"; # Did you read the comment?
}
