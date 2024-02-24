{ config, pkgs, lib, ... }:

{
	imports = [
		./waybar.nix
	];

	programs.sway = {
		enable = true;
		extraSessionCommands = let
			xkb = config.services.xserver.xkb;
		in ''
			eval $(gnome-keyring-daemon --start)
			export SSH_AUTH_SOCK
			export MOZ_ENABLE_WAYLAND=1
			export MOZ_DBUS_REMOTE=1
			${if xkb ? layout then
				"export XKB_DEFAULT_LAYOUT=\"${xkb.layout}\""
			else ""}
			${if xkb ? options then
				"export XKB_DEFAULT_OPTIONS=\"${xkb.options}\""
			else ""}
			${if xkb ? variant then
				"export XKB_DEFAULT_VARIANT=\"${xkb.variant}\""
			else ""}
		'';
		wrapperFeatures.gtk = true;
		extraPackages = (with pkgs; [
			playerctl
			wob
			acpi
			swayidle
			swaylock-fancy
			swaybg
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
			pavucontrol
			pamixer
			pulseaudio
			(writeScriptBin "pacycle" (builtins.readFile ../bin/pacycle))
			(writeScriptBin "sway-screenshot" (builtins.readFile ../bin/sway-screenshot))
			(writeScriptBin "sleep-if-battery" (builtins.readFile ../bin/sleep-if-battery))
		]);
	};

	services.gnome.gnome-keyring.enable = true;
	programs.seahorse.enable = true;

	environment = let
		mkConfig = pkgs.mylib.mkConfig ../config config.networking.hostName;
	in rec {
		variables.XCURSOR_THEME = "Quintom_Ink";
		loginShellInit = ''
			[[ "$(tty)" != '/dev/tty1' ]] || pidof sway > /dev/null || exec sway
		'';
		etc."sway/config".source = (mkConfig "sway" variables);
		etc."xdg/swayidle/config".source = (mkConfig "swayidle" {});
		etc."xdg/kanshi/config".source = (mkConfig "kanshi" {});
		etc."xdg/mako/config".source = (mkConfig "mako" {});
		etc."xdg/wob/wob.ini".source = (mkConfig "wob.ini" {});
		etc."sway/wallpaper.png".source = ../config/wallpaper.png;
	};
}
