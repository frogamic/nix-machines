args@{ config, pkgs, lib, ...} : let
	quintom-cursor-theme = with pkgs; stdenv.mkDerivation rec {
		name = "${package-name}-${version}";
		package-name = "quintom-cursor-theme";
		version = "d23e5733";

		src = builtins.fetchGit {
			url = "https://gitlab.com/Burning_Cube/quintom-cursor-theme.git";
			rev = "d23e57333e816033cf20481bdb47bb1245ed5d4d";
		};

		installPhase = ''
			mkdir -p $out/share/icons
			for theme in "Quintom_Ink" "Quintom_Snow"; do
				cp -r "$theme Cursors/$theme" $out/share/icons/
			done
		'';

		meta = {
			description = "Quintom Cursor Theme";
			platforms = lib.platforms.all;
		};
	};
in {
	imports = [
		./waybar.nix
	];
	services.xserver.displayManager.gdm = {
		#enable = true;
		wayland = true;
	};

	programs.sway = {
		enable = true;
		extraSessionCommands = ''
			export MOZ_ENABLE_WAYLAND=1
			${if config.services.xserver ? layout then
				"export XKB_DEFAULT_LAYOUT=\"${config.services.xserver.layout}\""
			else ""}
			${if config.services.xserver ? xkbOptions then
				"export XKB_DEFAULT_OPTIONS=\"${config.services.xserver.xkbOptions}\""
			else ""}
			${if config.services.xserver ? xkbVariant then
				"export XKB_DEFAULT_VARIANT=\"${config.services.xserver.xkbVariant}\""
			else ""}
		'';
		wrapperFeatures.gtk = true;
		extraPackages = (with pkgs; [
			playerctl
			pamixer
			wob
			swaylock
			swayidle
			xwayland
			mako
			libnotify
			grim
			slurp
			wl-clipboard
			wofi
			alacritty
			glib
			breeze-gtk
			breeze-qt5
			breeze-icons
		]) ++ [
			(pkgs.writeScriptBin "pacycle" (builtins.readFile ../bin/pacycle))
			(pkgs.writeScriptBin "sway-screenshot" (builtins.readFile ../bin/sway-screenshot))
			quintom-cursor-theme
		];
	};

	environment = let
		mkConfig = pkgs.mylib.mkConfig ../config config.networking.hostName;
	in rec {
		variables.XCURSOR_THEME = "Quintom_Ink";
		etc."sway/config".source = (mkConfig "sway-config" variables);
	};
}
