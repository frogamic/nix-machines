{ config, pkgs, ... } : {
	# Required for Discord and Chromium
	nixpkgs.config.allowUnfree = true;

	environment = {
		variables = {
			BROWSER = "firefox";
		};
		systemPackages =
		(with pkgs; [
			xdg-utils
			firefox-bin
			gimp
			gimpPlugins.gap
			inkscape
			krita
			drawio
			spotify
			discord
			mpv
			mupdf
			stable.chromium
			_1password-gui
		]) ++
		(with pkgs.xfce; [
			xfconf
			exo
			thunar
			thunar-volman
			thunar-archive-plugin
			tumbler
			ristretto
		]);
	};
}
