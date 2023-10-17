{ pkgs, ... }: with pkgs; {
	fonts.fonts = [
		font-awesome
	];
	environment.systemPackages = [
		waybar
	];
}
