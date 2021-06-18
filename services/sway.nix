{ config, pkgs, lib, ... } : {
	imports = [
		./waybar.nix
	];

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
			mypkgs.quintom-cursor-theme
		]) ++ [
			(pkgs.writeScriptBin "pacycle" (builtins.readFile ../bin/pacycle))
			(pkgs.writeScriptBin "sway-screenshot" (builtins.readFile ../bin/sway-screenshot))
		];
	};

	environment = let
		mkConfig = pkgs.mylib.mkConfig ../config config.networking.hostName;
	in rec {
		variables.XCURSOR_THEME = "Quintom_Ink";
		etc."sway/config".source = (mkConfig "sway-config" variables);
		etc."kanshi/config".source = (mkConfig "kanshi-config" {});
	};
}
