{ config, pkgs, ... }: {
	environment.systemPackages = (with pkgs; [
		gimp3-with-plugins
		inkscape-with-extensions
		krita
		stable.darktable
		exiftool
		drawio
	]);
	impermanence.persistence.user = {
		files = [
			".config/kritadisplayrc"
			".config/kritarc"
		];
		directories = [
			".cache/darktable"
			".config/darktable"
			".config/inkscape"
			".config/GIMP"
			".config/draw.io"
			".local/share/krita"
		];
	};
}
