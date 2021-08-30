{ config, pkgs, lib, ... } : {
	programs.sway = {
		enable = true;
		extraSessionCommands = ''
			eval $(gnome-keyring-daemon --start)
			export SSH_AUTH_SOCK
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
			waybar
			swaylock
			swayidle
			xwayland
			mako
			kanshi
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
			quintom-cursor-theme
		]) ++ [
			(pkgs.writeScriptBin "pacycle" (builtins.readFile ../bin/pacycle))
			(pkgs.writeScriptBin "sway-screenshot" (builtins.readFile ../bin/sway-screenshot))
		] ++ (
			if config.hardware.pulseaudio.enable then
				[ pkgs.pavucontrol ]
			else
				[ ]
			);
	};

	fonts.fonts = [
		pkgs.font-awesome
	];

	services.gnome.gnome-keyring.enable = true;
	programs.seahorse.enable = true;

	environment = let
		mkConfig = pkgs.mylib.mkConfig ../config config.networking.hostName;
	in rec {
		loginShellInit = ''
			[[ "$(tty)" != '/dev/tty1' ]] || pidof sway > /dev/null || exec sway
		'';
		variables.XCURSOR_THEME = "Quintom_Ink";
		etc."sway/config".source = (mkConfig "sway" variables);
		etc."xdg/kanshi/config".source = (mkConfig "kanshi" {});
		etc."xdg/mako/config".source = (mkConfig "mako" {});
		etc."xdg/waybar/config".source = (mkConfig "waybar" {});
		etc."xdg/waybar/style.css".source = (mkConfig "waybar.css" {});
	};
}
