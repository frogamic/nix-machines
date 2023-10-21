{ config, pkgs, ... }: with pkgs; {

	fonts.packages = [
		font-awesome
	];

	programs.sway.extraPackages = [
		waybar
	];

	environment = let
		mkConfig = pkgs.mylib.mkConfig ../config config.networking.hostName;
	in {
		etc."xdg/waybar/config".source = (mkConfig "waybar" {});
		etc."xdg/waybar/style.css".source = (mkConfig "waybar.css" {});
	};
}
