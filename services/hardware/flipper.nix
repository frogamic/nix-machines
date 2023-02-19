{ pkgs, ... }: with pkgs; {
	services.udev.packages = [ qFlipper ];
	environment.systemPackages = [ qFlipper ];
}
