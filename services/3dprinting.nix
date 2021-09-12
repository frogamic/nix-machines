{ pkgs, ... } : {
	environment.systemPackages = with pkgs; [
		super-slicer
		cura
		printrun
	];
}
