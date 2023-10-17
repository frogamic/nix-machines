{ pkgs, ... } : {
	fonts.fonts = with pkgs; [
		twemoji-color-font
		google-fonts
		liberation_ttf
		fira-mono
		vegur
		dejavu_fonts
	];
}
