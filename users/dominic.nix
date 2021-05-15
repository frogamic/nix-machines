{ config, pkgs, ... } : {
	users.users.dominic = {
		isNormalUser = true;
		shell = pkgs.zsh;
		extraGroups = import ./privileged-groups.nix config;
		openssh.authorizedKeys.keys = [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICzGL9KhRd2lKNuTZq1cK+4bkioGBkaMetfbzf/uuqTj dominic@enki"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE5rpMMLWs8oQXYtg9wXuvsb70O0vtPX+KEK1KiJAZVO dominic@ninhursag"
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvjSAq4gAGNM7Jp12rdTZ9uVTVd9iD2anhzRmFLmOoK dominic@macbook"
		];
	};
}
