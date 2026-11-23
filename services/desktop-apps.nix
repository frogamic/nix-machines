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
			discord
			mpv
			mupdf
			stable.chromium
			libreoffice
			hunspell
			hunspellDicts.en-au-large
			obsidian
			xfconf
			xfce4-exo
			ristretto
		];
	};

	xdg.mime = {
		defaultApplications = {
			"application/epub+zip" = "mupdf.desktop";
			"application/oxps" = "mupdf.desktop";
			"application/pdf" = "mupdf.desktop";
			"application/vnd.ms-xpsdocument" = "mupdf.desktop";
			"application/x-cbz" = "mupdf.desktop";
			"application/x-pdf" = "mupdf.desktop";

			"text/html" = "librewolf.desktop";
			"text/xml" = "librewolf.desktop";
			"application/xhtml+xml" = "librewolf.desktop";
			"application/xhtml_xml" = "librewolf.desktop";
			"application/xml" = "librewolf.desktop";
			"application/rdf+xml" = "librewolf.desktop";
			"application/rss+xml" = "librewolf.desktop";
			"application/vnd.mozilla.xul+xml" = "librewolf.desktop";
			"x-scheme-handler/http" = "librewolf.desktop";
			"x-scheme-handler/https" = "librewolf.desktop";

			"image/*" = "org.xfce.ristretto.desktop";

			"inode/directory" = "thunar.desktop";
			"inode/mount-point" = "thunar.desktop";
		};
	};

	programs = {
		thunar = {
			enable = true;
			plugins = with pkgs; [
				thunar-volman
				thunar-archive-plugin
			];
		};
		firefox = {
			enable = true;
			package = pkgs.librewolf;
			policies = {
				disableTelemetry = true;
				disableFirefoxStudies = true;
			};
		};
	};

	services.tumbler.enable = true;

	impermanence.persistence = {
		user = {
			directories = [
				".librewolf"
				".cache/librewolf"
				".config/discord"
				".config/Thunar"
				".config/libreoffice"
			];
		};
	};
}
