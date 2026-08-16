{ config, pkgs, ... } : {
	users.users.me = {
		name = "dominic";
		isNormalUser = true;
		shell = pkgs.zsh;
		extraGroups = [ "wheel" "dialout" ];
		openssh.authorizedKeys.keys = config.users.users.root.openssh.authorizedKeys.keys ++ [
			"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINKT5YGP5S7gMfM5wvm4dr6U5MAtlb6gDVaWsTGtDxd6 dominic@macbook"
		];
	};
}
