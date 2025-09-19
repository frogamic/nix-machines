{ config, pkgs, ... } : {
	# Required for Discord and Chromium
	nixpkgs.config.allowUnfree = true;

	environment = {
		variables = {
			BROWSER = "librewolf";
		};
		systemPackages =
		with pkgs; [
			xdg-utils
			spotify
			discord
			mpv
			mupdf
			stable.chromium
			libreoffice
			hunspell
			hunspellDicts.en-au-large
			obsidian
		] ++ (
			with xfce; [
				xfconf
				exo
				thunar
				thunar-volman
				thunar-archive-plugin
				tumbler
				ristretto
			]
		);
	};

	programs.firefox = {
		enable = true;
		package = pkgs.librewolf;
		policies = {
			disableTelemetry = true;
			disableFirefoxStudies = true;
		};
	};

	impermanence.persistence = {
		user = {
			directories = [
				".librewolf"
				".cache/librewolf"
				".config/discord"
				".config/Thunar"
				".config/spotify"
				".config/libreoffice"
			];
		};
	};
}
