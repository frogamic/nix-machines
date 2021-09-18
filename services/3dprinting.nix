{ pkgs, ... } : {
	environment.systemPackages = with pkgs; [
		super-slicer
		(cura.overrideAttrs (oldAttrs: {
			makeWrapperArgs = oldAttrs.makeWrapperArgs ++ [ "--set QT_QPA_PLATFORM xcb" ];
		}))
		printrun
	];
}
