{ config, pkgs, ... } : {
	users.users.me = {
		name = "dominic";
		isNormalUser = true;
		shell = pkgs.zsh;
		extraGroups = [ "wheel" "dialout" ];
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8rVaDV6tjSjVTrigsVnanK7rPf4FHl4qMpHSeO2j9b dominic@enlil"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5rpMMLWs8oQXYtg9wXuvsb70O0vtPX+KEK1KiJAZVO dominic@ninhursag"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKT5YGP5S7gMfM5wvm4dr6U5MAtlb6gDVaWsTGtDxd6 dominic@macbook"
		];
	};
}
