{ config, pkgs, ... } : {
	# Required for Discord and Chromium
	nixpkgs.config.allowUnfree = true;

	imports = [
		./steam.nix
		./photography.nix
		./3dprinting.nix
	];

	environment = {
		variables = {
			BROWSER = "firefox";
		};
		systemPackages =
		with pkgs; [
			xdg-utils
			firefox-bin
			gimp
			gimpPlugins.gap
			inkscape
			krita
			drawio
			spotify
			discord
			beeper
			mpv
			mupdf
			stable.chromium
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
