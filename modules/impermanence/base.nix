{ lib, config, ... }:
let
	prependList = pre: list: map (post: "${pre}${post}") list;
in
{
	impermanence.persistence = {
		files = (prependList "/etc/" [
			"machine-id"
			"wpa_supplicant.conf"
		]);
		directories = [
			config.boot.lanzaboote.pkiBundle
		] ++ (prependList "/var/" ([
				"log"
			] ++ (prependList "lib/" [
				"alsa"
				"bluetooth"
				"fprint"
				"nixos"
				"systemd"
			])
		));
		user = {
			files = [];
			directories = [
				"Desktop"
				"Documents"
				"Downloads"
				"Music"
				"Pictures"
				"Videos"
				"repos"
				".ssh"
				".gnupg"
				".mozilla/firefox"
				# ".wine"
			] ++ (prependList ".config/" [
				"discord"
				"dconf"
				"gtk-2.0"
				"gtk-3.0"
				# "gh"
				"Thunar"
				"xfce4"
			]) ++ (prependList ".cache/" [
				# "wine"
				# "winetricks"
				"zsh"
				"nix"
				"mozilla/firefox"
			]);
		};
	};
}
