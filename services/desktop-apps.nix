{ config, pkgs, ... } : {
	# Required for Discord and Chromium
	nixpkgs.config.allowUnfree = true;

	environment = {
		variables = {
			BROWSER = "firefox";
		};
		systemPackages =
		(with pkgs; let
			discordWayland = symlinkJoin {
				name = "discord";
				paths = [ discord ];
				buildInputs = [ makeWrapper ];
				postBuild = ''
					wrapProgram $out/bin/Discord --add-flags \
						"--enable-features=UseOzonePlatform --ozone-platform=wayland"
					mv $out/bin/discord $out/bin/Discord-Xwayland
					ln -s $out/bin/Discord $out/bin/discord
				'';
			};
		in [
			xdg-utils
			firefox-bin
			gimp
			gimpPlugins.gap
			inkscape
			krita
			drawio
			spotify
			discordWayland
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
