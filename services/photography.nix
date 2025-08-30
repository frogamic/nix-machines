{ config, pkgs, ... }: {
	environment.systemPackages = (with pkgs; [
		stable.darktable
		exiftool
	]);
}
