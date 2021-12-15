{ pkgs, ... }: {
	hardware.nitrokey.enable = true;
	users.users.me.extraGroups = [ "nitrokey" ];
	environment.systemPackages = [
		pkgs.mypkgs.pynitrokey
	];
}
