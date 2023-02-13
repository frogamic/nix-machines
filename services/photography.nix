{ config, pkgs, ... }: {
	environment.systemPackages = (with pkgs; [
		darktable
		exiftool
	]);
}
