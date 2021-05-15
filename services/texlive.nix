{ pkgs, ... } :  {
	environment.systemPackages = [
		pkgs.texlive.combined.scheme-medium
	];
}
