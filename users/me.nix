{ config, pkgs, ... } : {
	users.users.me = {
		name = "dominic";
		isNormalUser = true;
		shell = pkgs.zsh;
		extraGroups = [ "wheel" ];
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzGL9KhRd2lKNuTZq1cK+4bkioGBkaMetfbzf/uuqTj dominic@enki"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5rpMMLWs8oQXYtg9wXuvsb70O0vtPX+KEK1KiJAZVO dominic@ninhursag"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKT5YGP5S7gMfM5wvm4dr6U5MAtlb6gDVaWsTGtDxd6 dominic@macbook"
		];
	};
}
