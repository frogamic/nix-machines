{ pkgs, ... }:
{
	hardware.rtl-sdr.enable = true;
	users.users.me.extraGroups = [ "plugdev" ];
	environment.systemPackages = [
		pkgs.sdrpp
	];
}
