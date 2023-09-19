{ pkgs, ... }: with pkgs; {
	fonts.packages = [
		font-awesome
	];
	environment.systemPackages = [
		waybar
	];
}
