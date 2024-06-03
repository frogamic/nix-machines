{ config, pkgs, ... } : {
	# Required for Discord and Chromium
	nixpkgs.config.allowUnfree = true;

	environment = {
		variables = {
			BROWSER = "firefox";
		};
		systemPackages =
		with pkgs; [
			xdg-utils
			firefox-bin
			gimp
			inkscape
			krita
			drawio
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
}
